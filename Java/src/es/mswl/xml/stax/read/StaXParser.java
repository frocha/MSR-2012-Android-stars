package es.mswl.xml.stax.read;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.EndElement;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;

import es.mswl.xml.stax.model.Bug;

public class StaXParser {
	static final String BUG = "bug";
	static final String BUGID = "bugid";
	static final String STARS = "stars";
	static final String OPENEDDATE = "openedDate";
	static final String CLOSEDON = "closedOn";
	static final String PRIORITY = "priority";
	static final String TYPE = "type";


	@SuppressWarnings({ "unchecked", "null" })
	public List<Bug> readConfig(String configFile) {
		List<Bug> items = new ArrayList<Bug>();
		try {
			// First create a new XMLInputFactory
			XMLInputFactory inputFactory = XMLInputFactory.newInstance();
			// Setup a new eventReader
			InputStream in = new FileInputStream(configFile);
			XMLEventReader eventReader = inputFactory.createXMLEventReader(in);
			// Read the XML document
			Bug item = null;

			while (eventReader.hasNext()) {
				XMLEvent event = eventReader.nextEvent();

				if (event.isStartElement()) {
					StartElement startElement = event.asStartElement();
					// If we have a item element we create a new item
					if (startElement.getName().getLocalPart() == (BUG)) {
						item = new Bug();
						/*
						// In case we had attributes
						Iterator<Attribute> attributes = startElement
								.getAttributes();
						while (attributes.hasNext()) {
							Attribute attribute = attributes.next();
							if (attribute.getName().toString().equals(ATTRIBUTE_NAME)) {
								item.setDate(attribute.getValue());
							}

						}
						*/
					}

					if (event.isStartElement()) {
						if (event.asStartElement().getName().getLocalPart()
								.equals(BUGID)) {
							event = eventReader.nextEvent();
							item.setBugid(event.asCharacters().getData());
							continue;
						}
					}
					
					if (event.isStartElement()) {
						if (event.asStartElement().getName().getLocalPart()
								.equals(STARS)) {
							event = eventReader.nextEvent();
							item.setStars(Integer.parseInt(event.asCharacters().getData()));
							continue;
						}
					}
					
					if (event.isStartElement()) {
						if (event.asStartElement().getName().getLocalPart()
								.equals(OPENEDDATE)) {
							event = eventReader.nextEvent();
							item.setOpendedDate(event.asCharacters().getData());
							continue;
						}
					}
					
					if (event.isStartElement()) {
						if (event.asStartElement().getName().getLocalPart()
								.equals(CLOSEDON)) {
							event = eventReader.nextEvent();
							item.setClosedOn(event.asCharacters().getData());
							continue;
						}
					}
					
					if (event.isStartElement()) {
						if (event.asStartElement().getName().getLocalPart()
								.equals(PRIORITY)) {
							event = eventReader.nextEvent();
							if (event.isCharacters())
							{
								item.setPriority(event.asCharacters().getData());
							}
							else item.setPriority("null");
							continue;
						}
					}
					
					if (event.isStartElement()) {
						if (event.asStartElement().getName().getLocalPart()
								.equals(TYPE)) {
							event = eventReader.nextEvent();
							
							if (event.isCharacters())
							{
								item.setType(event.asCharacters().getData());
							}
							else item.setType("null");
							continue;
						}
					}
					
				}
				// If we reach the end of an item element we add it to the list
				if (event.isEndElement()) {
					EndElement endElement = event.asEndElement();
					if (endElement.getName().getLocalPart() == (BUG)) {
						if (!item.getClosedOn().equals("null")) items.add(item);
						System.out.println(item);
					}
				}

			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (XMLStreamException e) {
			e.printStackTrace();
		}
		return items;
	}

}