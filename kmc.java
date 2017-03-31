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
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.Vector;
import kmeansclustering.Data;

public class kmc {

    Data pointTuple;
    int k;
    public int n[];
    public double[][] classifiedDataPoints;
    public double[][] unclassifiedDataPoints;
    public double centroids[][]; //initial value of centroids
    public double newCentroids[][];
    public boolean checkCentroid;
    public boolean equalCentroids;
    static BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));

    //constructor
    public kmc(int numCentroids, String classified, String unclassified) {
        this.k = numCentroids;
        centroids = new double[numCentroids][3];
        n = new int[numCentroids];
        pointTuple = new Data();
        classifiedDataPoints = pointTuple.readTrainingFile(classified);
        unclassifiedDataPoints = pointTuple.readTestFile(unclassified);

        for (int i = 0; i < numCentroids; i++) {
            for (int j = 0; j < 2; j++) {
                centroids[i][j] = classifiedDataPoints[i][j];
            }
        }
    }

    //returns the Euclidean Distance between each point and the centroid
    public double getDistance(double[] dataRow, double[] centroid) {
        double d = 0.0;

        for (int i = 0; i < dataRow.length - 1; i++) {
            d += Math.pow(dataRow[i] - centroid[i], 2); //Euclidean distance
        }

        return (Math.sqrt(d));
    }

    //Returns the closest centroid to the point
    public int getClosestCentroid(double[] datum) {
        double min = Double.MAX_VALUE; //starts with minimum = centroids[0]
        int closestIndex = -1; //-1 because 0 could be a result value

        for (int i = 0; i < centroids.length; i++) { //for each centroid
            double d = getDistance(datum, centroids[i]); // between cluster centroid and object

            if (d < min) { //current distance is less than the minimum distance
                closestIndex = i; //k is now the location of the closest centroid
                min = d;
            }
        }
        return (closestIndex); //returns index of the closest centroid for current datum
    }

    //prints the data points
    public void printDatum(double[] datum) {
        Vector<Double> v = new Vector<Double>();

        for (int j = 0; j < datum.length - 1; j++) {
            v.add(new Double(datum[j]));
        }

        System.out.println(v);
    }

    //prints the centroids of the clusters
    public void printCentroids() {
        for (int i = 0; i < centroids.length; i++) {
            System.out.println("Centroid Number: " + (i+1));
            printDatum(centroids[i]);
        }

        System.out.println("-------------------");
    }

    //master function
    public void run() {
        boolean check = false;

        while (check == false) {

            boolean result = true;
            double newCentroids[][] = new double[k][3];// length = k

            for (int i = 0; i < k; i++) {
                n[i] = 0; //reset value of n[]
            }
            printCentroids();

            for (int i = 0; i < classifiedDataPoints.length; i++) { //ALL data objects
                int count = getClosestCentroid(classifiedDataPoints[i]); //gets closest centroid for ALL distances

                for (int j = 0; j < 3; j++) {
                    newCentroids[count][j] += classifiedDataPoints[i][j]; //sums all datum belonging to certain centroid 
                }
                n[count]++; //counts the no. of members of datum that belong to centroid group 
            }

            for (int i = 0; i < k; i++) {
                for (int j = 0; j < 3; j++) {
                    newCentroids[i][j] = newCentroids[i][j] / n[i];
                }
            }

            for (int i = 0; i < k; i++) {
                for (int j = 0; j < 2; j++) {
                    if (result == true) {
                        if (newCentroids[i][j] == centroids[i][j]) { //checks for stability
                            check = true;
                            result = true;
                        } else {
                            check = false;
                            result = false;
                        }
                    }
                }
            }

            centroids = newCentroids;
            getClassification(classifiedDataPoints, centroids);
        }
        try {
            printNewClassifications(unclassifiedDataPoints, newCentroids);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //Classifies the data points into clusters
    public void getClassification(double[][] datum, double[][] centroid) {

        int positive = 0; //represents 1
        int negative = 0; //represents 0 

        for (int i = 0; i < centroid.length; i++) {
            for (int j = 0; j < datum.length; j++) {
                if (i == getClosestCentroid(datum[j])) {
                    if (datum[j][2] == 1) {
                        positive++;
                    } else {
                        negative++;
                    }
                }

                if (positive > negative) {
                    centroid[i][2] = 1;
                } else {
                    centroid[i][2] = 0;
                }
            }

            positive = 0;
            negative = 0;
        }
    }

    //prints the classfied data
    public void printNewClassifications(double[][] unclassifiedData, double[][] centroid) throws IOException {

        FileWriter outputFile = new FileWriter("output.txt");
        PrintWriter outputPrint = new PrintWriter(outputFile);

        for (int i = 0; i < unclassifiedData.length; i++) {
            int closest = getClosestCentroid(unclassifiedData[i]);
            outputPrint.println((int) centroids[closest][2]);
        }

        outputPrint.println("");
        outputPrint.close();
    }

    public static void main(String args[]) throws IOException {

        Runtime rt = Runtime.getRuntime();
        long startTime = System.currentTimeMillis();

        System.out.println("Type number of centroids: ");
        String userInput = inFromUser.readLine();
        new kmc(Integer.parseInt(userInput), args[0], args[1]).run();
        
        long stopTime = System.currentTimeMillis();
        long elapsedTime = stopTime - startTime;
        System.out.println("Execution Time: "+elapsedTime+"ms\n");

        System.out.println("Free memory right now is : " + (rt.freeMemory() / (1024 * 1024)) + "mb.\n");

        System.out.println("Memory allocated by the jvm is:" + (rt.totalMemory()) / (1024 * 1024) + "mb.\n");

        System.out.println("Thus, the total memory being used is : " + (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024) + "mb.\n");
    }
}
