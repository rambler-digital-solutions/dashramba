package main

import (
	"fmt"
	"github.com/rambler-ios/dashramba/adapters/appstore_reviews"
)

func main() {
	result := appstore_reviews.ObtainDataForApplicationId("323214038")
	fmt.Println(string(result))
}