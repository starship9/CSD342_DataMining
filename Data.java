package kmeansclustering;

/*
K-MEANS CLUSTERING ASSIGNMENT IN JAVA

Group Number: 2

Group Members:
Manjul Singh Sachan (1410110228)
Mohak Garg (1410110247)
Nishank Saini (1410110266)

*/
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.StringTokenizer;

public class Data 
{
    public double[][] classifiedData;
    public double[][] unclassifiedData;
    public double token;
    public String currentLine;

    public Data()
    {
        classifiedData = new double[265][3];
        unclassifiedData = new double[100][2];
    }

    
    public double[][] readTrainingFile(String classified)
    {
        try {
            BufferedReader br = new BufferedReader(new FileReader(classified));
            currentLine = br.readLine(); 
            int row = 0;

            while (row < 265) { 
                StringTokenizer line = new StringTokenizer(currentLine); 
                int col = 0;

                while (line.hasMoreTokens()) { 
                    token = Double.parseDouble(line.nextToken()); 
                    classifiedData[row][col] = token; 
                    col++;
                }
                currentLine = br.readLine(); 
                row++;
            }
        } 

        catch (FileNotFoundException e) { 
            System.out.println("Error: " + e);
        } 

        catch (IOException e) {
            System.out.println("Error: " + e);
        }

        return classifiedData; 
    }

    
    public double[][] readTestFile(String unclassified)
    {
        try {
            BufferedReader br = new BufferedReader(new FileReader(unclassified));
            currentLine = br.readLine(); 
            int row = 0;

            while (row < 100) { 
                StringTokenizer line = new StringTokenizer(currentLine);
                int col = 0;

                while (line.hasMoreTokens()) { 
                    token = Double.parseDouble(line.nextToken()); 
                    unclassifiedData[row][col] = token; 
                    col++;
                }
                currentLine = br.readLine(); 
                row++;
            }
        } 

        catch (FileNotFoundException e) { 
            System.out.println("Error: " + e);
        } 

        catch (IOException e) {
            System.out.println("Error: " + e);
        }

        return unclassifiedData; 
    }
}    

