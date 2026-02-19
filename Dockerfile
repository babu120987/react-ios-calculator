# -------- Stage 1: Build --------
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies first (better caching)
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build the Vite app
RUN npm run build


# -------- Stage 2: Production --------
FROM nginx:stable-alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config (optional but recommended)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
