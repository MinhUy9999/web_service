package main

import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()

	// Chạy server
	r.Run(":3000") // Server chạy tại http://localhost:8080
}
