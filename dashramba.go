package main

import (
	"log"
)

func init() {
}

func main() {
	adapters := AdaptersFromDirectory("adapters")
	log.Println(adapters)
}
