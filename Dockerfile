# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependencies
COPY package*.json ./
RUN npm ci

# Copy the full project and build
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

WORKDIR /app

# Copy only the necessary output from the builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npx", "next", "start"]
