void setup() {
  String[] lines = {
    "# My Markdown File",
    "",
    "This is some text written from Processing.",
    "",
    "You can add more content to this file by modifying the 'lines' array.",
    "",
    "Happy coding!"
  };

  // Use the relative path to your .md file.
  String filePath = "data/your_file.md";
  saveStrings(filePath, lines);
  println("Markdown file saved!");
}

void draw() {
  // Your drawing code (if any) goes here
}
