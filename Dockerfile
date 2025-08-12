# Build stage
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++ gcc libc-dev

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with proper platform
RUN npm ci --platform=linux --arch=x64 || npm install

# Rebuild native modules for Alpine Linux
RUN npm rebuild

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy built application
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]