package main

import "fmt"
import "encoding/json"
import "net/http"
import "io/ioutil"

type ItunesFeed struct {
	Feed struct {
		Entries []struct {
			Author struct {
				Name struct {
					Label string `json:"label"`
				} `json:"name"`
			} `json:"author"`
			Rating struct {
				Label string `json:"label"`
			} `json:"im:rating"`
			Title struct {
				Label string `json:"label"`
			} `json:"title"`
			Content struct {
				Label string `json:"label"`
			} `json:"content"`
		} `json:"entry"`
	} `json:"feed"`
}

func main() {
	response, error := http.Get("https://itunes.apple.com/ru/rss/customerreviews/id=323214038/sortBy=mostRecent/json")
	defer response.Body.Close()
	if error != nil {
		// handle error
	}
	body, error := ioutil.ReadAll(response.Body)
	if error != nil {
		// handle error
	}

	var feed ItunesFeed
	json.Unmarshal(body, &feed)

    var reviews = feed.Feed.Entries[1:]
    fmt.Println(reviews[0])
}