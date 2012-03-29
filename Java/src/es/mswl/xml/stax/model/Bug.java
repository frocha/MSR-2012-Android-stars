package es.mswl.xml.stax.model;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class Bug {
	private String bugid;
	private int stars;
	private String openedDate;
	private String closedOn;
	private String priority;
	private String type;

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getBugid() {
		return bugid;
	}
	
	public void setBugid(String bugid) {
		this.bugid = bugid;
	}
	
	public int getStars() {
		return stars;
	}
	
	public void setStars(int stars) {
		this.stars = stars;
	}
	
	public String getOpendedDate() {
		return openedDate;
	}

	public void setOpendedDate(String opendedDate) {
		this.openedDate = opendedDate;
	}

	public String getClosedOn() {
		return closedOn;
	}

	public void setClosedOn(String closedOn) {
		this.closedOn = closedOn;
	}
	
	public long getDuration() {
		long seconds = -1;

		if (!closedOn.equals("null"))
		{
			Calendar openedDateCal = getCalendar(openedDate, "EEE, dd MMM yyyy HH:mm:ss Z");
			Calendar closedOnCal = getCalendar(closedOn.replaceAll("T", " ").replaceAll(".000Z", " +0000"), "yyyy-MM-dd HH:mm:ss Z");

			seconds = ( closedOnCal.getTimeInMillis() - openedDateCal.getTimeInMillis() ) / 1000;
		}
		return seconds;
	}
	
	private Calendar getCalendar(String dateToParse, String dateFormat)
	{
		DateFormat df = new SimpleDateFormat(dateFormat);
		Date date = null;
		try {
			date = df.parse(dateToParse);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return cal;
	}
	
	@Override
	public String toString() {
				return "Bug [bugid=" + bugid + ", stars=" + stars + ", openedDate=" + openedDate + ", closedOn=" + closedOn + ", duration=" + getDuration() + "]";
	}

}
