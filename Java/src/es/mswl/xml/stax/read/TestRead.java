package es.mswl.xml.stax.read;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import es.mswl.xml.stax.model.*;

public class TestRead {
	public static void main(String args[]) {
		
		int maxStars = 0;
		int minStars = 23;
		int stars = 0;
		
		long duration = 0;
		long maxDuration = 0;
		long minDuration = 609981;
		
		StaXParser read = new StaXParser();
		List<Bug> readConfig = read.readConfig("android_platform_bugs.xml"); 
		//List<Bug> readConfig = read.readConfig("bugs.xml");
	
		System.out.println("-------------------------------------------");
		System.out.println("Processing bugs...");
		
		try {
			FileWriter outFile = new FileWriter("bug_stars_duration.txt");
			PrintWriter out = new PrintWriter(outFile);
			out.println("Stars Duration Type Priority");
			
			for (Bug item : readConfig) {
				//System.out.println(item);

				stars = item.getStars();
				duration = item.getDuration();

				if (stars > maxStars) maxStars = stars;
				if (stars < minStars) minStars = stars;
				if (duration > maxDuration) maxDuration = duration;
				if ( (duration < minDuration) && (duration != -1) ) minDuration = duration;

				out.println(stars + " " + duration + " " + item.getType() + " " + item.getPriority());

			}
			
			out.close();
		} catch (IOException e){
			e.printStackTrace();
		}
		
		System.out.println("-------------------------------------------");
		System.out.println("Total number of bugs: " + readConfig.size());
		System.out.println("Max. Stars: " + maxStars);
		System.out.println("Min. Stars: " + minStars);
		System.out.println("Max. duration (sec): " + maxDuration);
		System.out.println("Min. duration (sec): " + minDuration);
		
		
		// parse closedOn
		// 2010-08-10T04:20:10.000Z
		//
		// Count number of bugs that has been closed
		// cat android_platform_bugs.xml | grep "<closedOn>" | grep -v "<closedOn>null</closedOn>" | wc -l		
		//
		// Count number of bugs that has been closed, have a "T" before the time and ".000Z" as time zone 
		// cat android_platform_bugs.xml | grep "<closedOn>[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.000Z" | wc -l
		//
		// Both counts are 6345
		
		// Count number of bugs that have +0000 as time zone
		// cat android_platform_bugs.xml | grep "<openedDate>.\{27\}\+0000" | wc -l
		//
		// Count total number of bugs
		// cat android_platform_bugs.xml | grep "<openedDate>" | wc -l
		//
		// Both counts are equal
		
	}
}
