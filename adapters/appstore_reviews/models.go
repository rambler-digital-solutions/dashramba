package appstore_reviews

type RawITunesFeed struct {
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

type AppReview struct {
	AuthorName string `json:"author_name"`
	Title string `json:"title"`
	Content string `json:"content"`
	Rating string `json:"rating"`
}