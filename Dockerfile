################################### Stage 1: Builder
FROM node:18-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .

##################################### Stage 2: Runtime
FROM node:18-alpine

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --from=builder /app .

# Run app as non-root user
USER appuser


ENV PORT=3000
EXPOSE 3000 

CMD ["node", "server.js"]

