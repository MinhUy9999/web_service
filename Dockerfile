# Sử dụng hình ảnh Go chính thức
FROM golang:1.22 AS builder

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Copy các tệp cần thiết vào container
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Biên dịch ứng dụng thành tệp nhị phân
RUN go build -o main .

# Tạo một lightweight container để chạy ứng dụng
FROM debian:bullseye-slim

# Cài đặt các công cụ cơ bản nếu cần (tùy chọn)
RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates

# Thư mục làm việc
WORKDIR /root/

# Copy tệp nhị phân từ builder sang container này
COPY --from=builder /app/main .

# Expose cổng server
EXPOSE 3000

# Lệnh khởi chạy ứng dụng
CMD ["./main"]
