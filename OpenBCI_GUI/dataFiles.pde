import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
////////////////////////////////////////////////////////////
// Class: OutputFile_rawtxt
// Purpose: handle file creation and writing for the text log file
// Created: Chip Audette  May 2, 2014
//
//write data to a text file

class queue 
{
  float[] que;
    int     count;
    int T;
  
    queue()
    {
      que = new float[256 * 2 * 5 ];
      
      for(int i = 0 ; i<256*2*5 ; i++)
      {
        que[i] = -1;
      
      
      }
      
      
      count = 0;
      
      T = 5;
    }
    
    void push(float a)
    {
      if(count != 256*2*T)
      {
        que[count] = a;
        count++;
      }
      else
      {
        int i = 0;
        while(i < 256*2*T-1)
        {
          que[i] = que[i+1];
          i++;
        }
        que[i] = a;
      }
    }
    
    void que_print()
    {
      for(int i = 0 ; i<256*2*T ; i++)
    {
      System.out.println(que[i]);
    }
    }
    
    void Print_to_txt(String fileName) 
    {   
        FileWriter writer = null;  
        try {     
            
            writer = new FileWriter(fileName, false);     
            //writer.write(content); 
            for(int i = 0 ; i<256*2*T ; i++)
        {
              writer.write(String.valueOf(que[i]));
              writer.write("\n");
        }
        } catch (IOException e) {     
            e.printStackTrace();     }
       
        try {     
            if(writer != null){  
                writer.close(); 
                
            }  
        } catch (IOException e) {     
            e.printStackTrace();     
        }     
     }

}

public class OutputFile_rawtxt {
  PrintWriter output;
  String fname;
  private int rowsWritten;

  OutputFile_rawtxt(float fs_Hz) {

    //build up the file name
    fname = "SavedData\\OpenBCI-RAW-";

    //add year month day to the file name
    fname = fname + year() + "-";
    if (month() < 10) fname=fname+"0";
    fname = fname + month() + "-";
    if (day() < 10) fname = fname + "0";
    fname = fname + day(); 

    //add hour minute sec to the file name
    fname = fname + "_";
    if (hour() < 10) fname = fname + "0";
    fname = fname + hour() + "-";
    if (minute() < 10) fname = fname + "0";
    fname = fname + minute() + "-";
    if (second() < 10) fname = fname + "0";
    fname = fname + second();

    //add the extension
    fname = fname + ".txt";

    //open the file
    output = createWriter(fname);

    //add the header
    writeHeader(fs_Hz);
    
    //init the counter
    rowsWritten = 0;
  }

  //variation on constructor to have custom name
  OutputFile_rawtxt(float fs_Hz, String _fileName) {
    fname = "SavedData\\OpenBCI-RAW-";
    fname += _fileName;
    fname += ".txt";
    output = createWriter(fname);        //open the file
    writeHeader(fs_Hz);    //add the header
    rowsWritten = 0;    //init the counter
  }

  public void writeHeader(float fs_Hz) {
    output.println("%OpenBCI Raw EEG Data");
    output.println("%");
    output.println("%Sample Rate = " + fs_Hz + " Hz");
    output.println("%First Column = SampleIndex");
    output.println("%Other Columns = EEG data in microvolts followed by Accel Data (in G) interleaved with Aux Data");
    output.flush();
  }


//  public void writeRawData_dataPacket(DataPacket_ADS1299 data, float scale_to_uV, float scale_for_aux) {
//    writeRawData_dataPacket(data, scale_to_uV, data.values.length);
//  }

  queue qu = new queue();
  public void writeRawData_dataPacket(DataPacket_ADS1299 data, float scale_to_uV, float scale_for_aux) {
    
    
    
    if (output != null) {
      output.print(Integer.toString(data.sampleIndex));
      
      //println(data.sampleIndex);
      
      //writeValues(data.values,scale_to_uV);
      //writeValues(data.auxValues,scale_for_aux);
      
      /*
      choose data.values[0]+data.values[1] to be my new data to FFT 
      */
      //println( scale_to_uV * float(data.values[0]) );
      
      qu.push( scale_to_uV * float(data.values[0]) );
      //qu.push( scale_to_uV * float(data.values[1]) );
      qu.Print_to_txt("G:/Git/Online_SSVEP/Data_handling/Data.txt");
      
      
      
      output.println(); rowsWritten++;
      //output.flush();
    }
  }
  
  private void writeValues(int[] values, float scale_fac) {          
    int nVal = values.length;
    for (int Ival = 0; Ival < nVal; Ival++) {
      output.print(", ");
      output.print(String.format("%.2f", scale_fac * float(values[Ival])));
      
      //println( scale_fac * float(values[Ival]) );
    }
  }



  public void closeFile() {
    output.flush();
    output.close();
  }

  public int getRowsWritten() {
    return rowsWritten;
  }
}


///////////////////////////////////////////////////////////////
// Class: Table_CSV
// Purpose: Extend the Table class to handle data files with comment lines
// Created: Chip Audette  May 2, 2014
//
// Usage: Only invoke this object when you want to read in a data
//    file in CSV format.  Read it in at the time of creation via
//    
//    String fname = "myfile.csv";
//    TableCSV myTable = new TableCSV(fname);
//
//import java.io.*; 
//import processing.core.PApplet;
class Table_CSV extends Table {
  Table_CSV(String fname) throws IOException {
    init();
    readCSV(PApplet.createReader(createInput(fname)));
  }

  //this function is nearly completely copied from parseBasic from Table.java
  void readCSV(BufferedReader reader) throws IOException {
    boolean header=false;  //added by Chip, May 2, 2014;
    boolean tsv = false;  //added by Chip, May 2, 2014;

    String line = null;
    int row = 0;
    if (rowCount == 0) {
      setRowCount(10);
    }
    //int prev = 0;  //-1;
    try {
      while ( (line = reader.readLine ()) != null) {
        //added by Chip, May 2, 2014 to ignore lines that are comments
        if (line.charAt(0) == '%') {
          //println("Table_CSV: readCSV: ignoring commented line...");
          continue;
        }

        if (row == getRowCount()) {
          setRowCount(row << 1);
        }
        if (row == 0 && header) {
          setColumnTitles(tsv ? PApplet.split(line, '\t') : splitLineCSV(line));
          header = false;
        } 
        else {
          setRow(row, tsv ? PApplet.split(line, '\t') : splitLineCSV(line));
          row++;
        }

        // this is problematic unless we're going to calculate rowCount first
        if (row % 10000 == 0) {
          /*
        if (row < rowCount) {
           int pct = (100 * row) / rowCount;
           if (pct != prev) {  // also prevents "0%" from showing up
           System.out.println(pct + "%");
           prev = pct;
           }
           }
           */
          try {
            // Sleep this thread so that the GC can catch up
            Thread.sleep(10);
          } 
          catch (InterruptedException e) {
            e.printStackTrace();
          }
        }
      }
    } 
    catch (Exception e) {
      throw new RuntimeException("Error reading table on line " + row, e);
    }
    // shorten or lengthen based on what's left
    if (row != getRowCount()) {
      setRowCount(row);
    }
  }
}

