#!/bin/bash
set -e

echo "Running database migrations..."
pnpm dlx prisma db push --schema ./libraries/nestjs-libraries/src/database/prisma/schema.prisma --accept-data-loss

echo "Database migrations completed!"
