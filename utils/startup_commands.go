package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	/*get the variable that containt the key start_up_command */
	var commands []string
	for _, element := range os.Environ() {
		variable := strings.Split(element, "=")
		if strings.Contains(variable[0], "STARTUP_COMMAND") {
			commands = append(commands, variable[1])
		}
	}
	reverse(commands)
	/* resort the error  */
	var commandChain = ""
	for _, command := range commands {
		command = command + ";"
		commandChain += command
	}
	cmd := exec.Command("bash", "-c", commandChain)
	stdout, err := cmd.Output()

	if err != nil {
		fmt.Println(err.Error())
		return
	}
	// Print the output
	fmt.Println(string(stdout))
}

func reverse(ss []string) {
	last := len(ss) - 1
	for i := 0; i < len(ss)/2; i++ {
		ss[i], ss[last-i] = ss[last-i], ss[i]
	}
}
