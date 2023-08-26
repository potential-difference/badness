// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require('vscode');

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
	let disposable = vscode.commands.registerCommand('extension.manageTask', async () => {
        const runningTasks = await vscode.tasks.fetchTasks();

        // Replace 'yourTaskName' with your task's name
        const taskName = 'Run Processing Sketch';

        const taskToTerminate = runningTasks.find(task => task.name === taskName);

        if (taskToTerminate) {
            // Terminate the task
			taskToTerminate.terminate();			
            // Execute the task again
            const taskDefinition = {
                type: 'shell', // Replace with the task type you are using
                label: taskName,
                command: '${config:processing.path}', // Replace with the actual command
                args: ["--force",
				"--sketch=${workspaceRoot}",
				"--output=${workspaceRoot}/out",
				"--run"], // Replace with command arguments
            };

            vscode.tasks.executeTask(taskDefinition);
        }
    


	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log('Congratulations, your extension "force-run-processing" is now active!');

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with  registerCommand
	// The commandId parameter must match the command field in package.json
	let disposable = vscode.commands.registerCommand('force-run-processing.helloWorld', function () {
		// The code you place here will be executed every time your command is executed

		// Display a message box to the user
		vscode.window.showInformationMessage('Hello World from force run processing!');
	});

	context.subscriptions.push(disposable);

});}

// This method is called when your extension is deactivated
function deactivate() {}

module.exports = {
	activate,
	deactivate
}
