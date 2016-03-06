package appstore_reviews

import (
	"testing"
)

func TestObtainDataForAppId(t *testing.T) {
	result := ObtainDataForApplicationId("323214038")
	if result == nil {
		t.Fatalf("is nil")
	}
}