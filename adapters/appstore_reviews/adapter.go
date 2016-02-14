package main

import (
	"fmt"
	"encoding/json"
	"net/http"
	"io/ioutil"
)

func ObtainDataForApplicationId(appId string) []byte {
	response, error := http.Get("https://itunes.apple.com/ru/rss/customerreviews/id=" + appId + "/sortBy=mostRecent/json")
	defer response.Body.Close()
	if error != nil {
		// handle error
	}
	body, error := ioutil.ReadAll(response.Body)
	if error != nil {
		// handle error
	}

	var feed RawITunesFeed
	json.Unmarshal(body, &feed)

    var entries = feed.Feed.Entries[1:]
    var reviews []AppReview
    for _, entry := range entries {
        review := new(AppReview)
        review.AuthorName = entry.Author.Name.Label
        review.Title = entry.Title.Label
        review.Content = entry.Content.Label
        review.Rating = entry.Rating.Label
        reviews = append(reviews, *review)
    }

    marshalledReviews, error := json.MarshalIndent(reviews, "", " ")
    if error != nil {
        fmt.Println(error)
        return nil
    }
    return marshalledReviews
}