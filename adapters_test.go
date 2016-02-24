package main

import (
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"testing"
)

func TestAdaptersFromDirectory(t *testing.T) {
	dir, err := ioutil.TempDir("", "example")
	if err != nil {
		t.Fatal(err)
	}

	defer os.RemoveAll(dir) // clean up

	files := []string{"file1", "file2", "file3_adapter", "file4_adapter"}
	for _, name := range files {
		file, err := os.Create(path.Join(dir, name))
		if err != nil {
			t.Fatal(err)
		}
		file.Close()
	}

	expectedAdapters := map[string]bool{
		"file3": false,
		"file4": false,
	}

	adapters := AdaptersFromDirectory(dir)

	for _, adapter := range adapters {
		expectedAdapters[adapter.Title()] = true
	}

	for name, presented := range expectedAdapters {
		if presented == false {
			t.Fatalf("Adapter %s isn't presented", name)
		}
	}
}

func TestFileAdapterExecuteCommand(t *testing.T) {
	cmd := exec.Command("echo", "Hello, world")
	adapter := &FileAdapter{Name: "test", Command: cmd}

	if result, _ := adapter.Execute(); result != "Hello, world\n" {
		t.Errorf("Invalid result string %s", result)
	}
}
