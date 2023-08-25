import processing.data.*;

void setup() {
  // Prepare your data (example JSON object)
  JSONObject data = new JSONObject();
  data.setInt("score", 100);
  data.setString("name", "John Doe");
  data.setBoolean("active", true);

  // Specify the relative path to the file (change the path and filename as per your needs)
  String relativePath = "data/mydata.json";

  // Create the JSON file and write the data
  saveJSONObject(data, relativePath);

  // Print a message to confirm that the file was saved
  println("Data saved to " + relativePath);
}
