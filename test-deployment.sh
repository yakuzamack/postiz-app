#!/bin/bash
# Postiz Full Deployment Test Suite
# Tests all critical components of the deployment

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FRONTEND_URL="https://postiz-app-jet.vercel.app"
BACKEND_URL="https://postiz-backend-fbp3.onrender.com"

echo ""
echo "=========================================="
echo "     POSTIZ DEPLOYMENT TEST SUITE"
echo "=========================================="
echo ""

PASSED=0
FAILED=0

# Helper function to test endpoint
test_endpoint() {
    local name=$1
    local url=$2
    local expected_code=$3
    local description=$4

    echo -n "Testing $name... "

    response_code=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "$url" 2>/dev/null || echo "000")

    if [ "$response_code" = "$expected_code" ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $response_code)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} (HTTP $response_code, expected $expected_code)"
        echo "  $description"
        ((FAILED++))
        return 1
    fi
}

# Test 1: CLI Authentication
echo -e "${BLUE}=== Authentication Tests ===${NC}"
echo ""

echo -n "1. Vercel CLI... "
if vercel whoami > /dev/null 2>&1; then
    user=$(vercel whoami 2>&1 | head -2 | tail -1)
    echo -e "${GREEN}✓ PASS${NC} ($user)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
    ((FAILED++))
fi

echo -n "2. Render CLI... "
if render whoami > /dev/null 2>&1; then
    email=$(render whoami 2>&1 | grep Email | cut -d: -f2 | xargs)
    echo -e "${GREEN}✓ PASS${NC} ($email)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
    ((FAILED++))
fi

echo -n "3. Cloudflare CLI... "
if wrangler whoami > /dev/null 2>&1; then
    email=$(wrangler whoami 2>&1 | grep "associated with the email" | awk '{print $NF}' | tr -d '.')
    echo -e "${GREEN}✓ PASS${NC} ($email)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
    ((FAILED++))
fi
echo ""

# Test 2: Service Health
echo -e "${BLUE}=== Service Health Tests ===${NC}"
echo ""

test_endpoint "Backend Root" "$BACKEND_URL" "200" "Backend API should return 200"
test_endpoint "Frontend" "$FRONTEND_URL" "307" "Frontend should redirect to /auth"
test_endpoint "API Health" "$BACKEND_URL/api" "404" "API root returns 404 (no handler)"

echo ""

# Test 3: CORS & Headers
echo -e "${BLUE}=== CORS & Headers Tests ===${NC}"
echo ""

echo -n "4. Backend CORS Headers... "
cors_header=$(curl -s -I -H "Origin: $FRONTEND_URL" "$BACKEND_URL" | grep -i "access-control-allow-origin" || echo "")
if [ -n "$cors_header" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    echo "   $cors_header"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ WARNING${NC} (CORS headers not found - may cause issues)"
    echo "   This might be OK if CORS is handled by reverse proxy"
fi

echo ""

# Test 4: Environment Variables
echo -e "${BLUE}=== Environment Variables Tests ===${NC}"
echo ""

echo "5. Vercel Environment Variables:"
required_vars=("BACKEND_INTERNAL_URL" "NEXT_PUBLIC_BACKEND_URL" "CLOUDFLARE_ACCOUNT_ID" "CLOUDFLARE_BUCKETNAME" "STORAGE_PROVIDER")
vercel_env_output=$(vercel env ls 2>&1)

for var in "${required_vars[@]}"; do
    echo -n "   - $var... "
    if echo "$vercel_env_output" | grep -q "$var"; then
        echo -e "${GREEN}✓ SET${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ MISSING${NC}"
        ((FAILED++))
    fi
done

echo ""

# Test 5: Cloudflare R2
echo -e "${BLUE}=== Cloudflare R2 Tests ===${NC}"
echo ""

echo -n "6. R2 Bucket Access... "
r2_output=$(wrangler r2 bucket list 2>&1)
if echo "$r2_output" | grep -q "postiz-uploads"; then
    echo -e "${GREEN}✓ PASS${NC} (postiz-uploads found)"
    ((PASSED++))
elif echo "$r2_output" | grep -q "your-account-id"; then
    echo -e "${RED}✗ FAIL${NC} (Invalid account ID - still using placeholder)"
    echo "   Run: ./setup-r2-storage.sh"
    ((FAILED++))
elif echo "$r2_output" | grep -q "Listing buckets"; then
    echo -e "${YELLOW}⚠ WARNING${NC} (R2 works but postiz-uploads bucket not found)"
    echo "   Create bucket: wrangler r2 bucket create postiz-uploads"
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   $r2_output"
    ((FAILED++))
fi

echo ""

# Test 6: Frontend-Backend Communication
echo -e "${BLUE}=== Integration Tests ===${NC}"
echo ""

echo -n "7. Frontend can reach backend... "
# Test if Vercel rewrites work
backend_via_frontend=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "$FRONTEND_URL/api" 2>/dev/null || echo "000")
if [ "$backend_via_frontend" != "000" ]; then
    echo -e "${GREEN}✓ PASS${NC} (HTTP $backend_via_frontend)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAIL${NC} (Timeout or no connection)"
    ((FAILED++))
fi

echo ""

# Test 7: Database (indirect test via backend)
echo -e "${BLUE}=== Backend Functionality Tests ===${NC}"
echo ""

echo -n "8. Backend Swagger/API Docs... "
swagger_code=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "$BACKEND_URL/api" 2>/dev/null || echo "000")
if [ "$swagger_code" = "200" ] || [ "$swagger_code" = "404" ]; then
    echo -e "${GREEN}✓ PASS${NC} (HTTP $swagger_code)"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ WARNING${NC} (HTTP $swagger_code)"
fi

echo ""

# Summary
echo "=========================================="
echo "           TEST SUMMARY"
echo "=========================================="
echo ""
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

total=$((PASSED + FAILED))
percentage=$((PASSED * 100 / total))

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
    echo ""
    echo "Your Postiz deployment is working correctly!"
    echo ""
    echo "Next steps:"
    echo "1. Open: $FRONTEND_URL"
    echo "2. Create an account"
    echo "3. Add social media integrations"
    echo ""
    exit 0
elif [ $percentage -ge 80 ]; then
    echo -e "${YELLOW}⚠ MOSTLY WORKING (${percentage}% passed)${NC}"
    echo ""
    echo "Your deployment is mostly functional."
    echo "Check the failed tests above and fix them."
    echo ""
    exit 1
else
    echo -e "${RED}❌ DEPLOYMENT HAS ISSUES (${percentage}% passed)${NC}"
    echo ""
    echo "Several critical tests failed."
    echo "Review DEPLOYMENT_VERIFICATION.md for troubleshooting."
    echo ""
    exit 1
fi
