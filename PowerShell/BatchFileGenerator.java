import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
public class BatchFileGenerator {
	public static void main(String[] args) {
		File directory = new File(System.getProperty("user.dir"));
		Set<File> uniqueFiles = new HashSet<>();
		processDirectory(directory, uniqueFiles);
		for (File file : uniqueFiles) createBat(file);
	}
	private static void processDirectory(File dir, Set<File> uniqueFiles) {
		if (!dir.exists() || !dir.isDirectory()) return;
		File[] files = dir.listFiles();
		if (files == null || files.length == 0) {
			if (files != null && files.length == 0) System.out.println("No files were found in the directory");
			return;
		}
		for (File file : files) {
			if (file.isDirectory()) {
				processDirectory(file, uniqueFiles);
			} else if (file.getName().toLowerCase().endsWith(".ps1") && !uniqueFiles.contains(file)) {
				System.out.println("Found PowerShell Script file " + file.getAbsolutePath());
				uniqueFiles.add(file);
			}
		}
	}
	private static void createBat(File file) {
		try {
			String name = file.getName().replaceFirst("[.][^.]+$", "");
			File batFile = new File(file.getParent(), name + ".bat");
			try (FileWriter writer = new FileWriter(batFile)){
				String[] lines = {"@echo off", "\nset \"scriptName=" + name + "\"", "\npowershell -ExecutionPolicy Bypass -NoProfile -NoExit -File \"%~dp0%scriptName%.ps1"};
				for (String line : lines) writer.write(line);
				System.out.println("Successfully created: " + batFile.getAbsolutePath());
			} catch (IOException e) {
				System.err.println("Error writing to .bat file for: " + file.getAbsolutePath() + "\nMessage: " + e.getMessage());
				e.printStackTrace();
			}
		} catch (Exception e) {
			System.err.println("Error creating .bat file for: " + file.getAbsolutePath() + "\n Message: " + e.getMessage());
			e.printStackTrace();
		}
	}

}