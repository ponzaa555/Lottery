package main

import (
	"fmt"

	"github.com/Napon/cinema/movie"
	"github.com/Napon/cinema/ticket"
)

func main() {
	movieName := movie.FindMovieName("tt4154796")
	fmt.Println(movieName)
	movie.ReviewMovie(movieName, 8.4)
	ticket.BuyTicket(movieName)
}

// อยาก import function จาก project อื่นมาใช้งาน
/* 1) go mod init ชื่อโปรเจ็คนี้  : จะได้ ไฟล์ go.mod มา
   2)go mod tidy : จะโหลด ไฟล์function ที่ต้องใช้มา

