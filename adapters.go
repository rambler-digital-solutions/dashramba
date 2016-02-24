package main

import (
	"bytes"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path"
	"strings"
)

type Adapter interface {
	Title() string
	Execute() (interface{}, error)
}

type FileAdapter struct {
	Name    string
	Command *exec.Cmd
}

func (a *FileAdapter) Title() string {
	return a.Name
}

func (a *FileAdapter) String() string {
	return a.Name
}

func (a *FileAdapter) Execute() (interface{}, error) {
	var out bytes.Buffer
	var cmd = a.Command

	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return nil, err
	}

	return out.String(), nil
}

func AdaptersFromDirectory(dir string) []Adapter {
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		log.Fatal(err)
	}
	suffixLen := len("_adapter")
	adapters := make([]Adapter, 0, 1024)
	for _, file := range files {
		if isAdapter(file) {
			path := path.Join(dir, file.Name())
			cmd := &exec.Cmd{Path: path}
			name := file.Name()[:len(file.Name())-suffixLen]
			adapters = append(adapters, &FileAdapter{Name: name, Command: cmd})
		}
	}

	return adapters
}

func isAdapter(f os.FileInfo) bool {
	return strings.HasSuffix(f.Name(), "_adapter")
}
