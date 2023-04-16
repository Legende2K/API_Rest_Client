package com.octest.beans;

public class Distance {
	public static int distance(Ville ville1, Ville ville2) {
		double lat1 = Double.parseDouble(ville1.getLatitude());
		double lon1 = Double.parseDouble(ville1.getLongitude());
		double lat2 = Double.parseDouble(ville2.getLatitude());
		double lon2 = Double.parseDouble(ville2.getLongitude());

		double theta = lon1 - lon2;
		double dist = Math.sin(Math.toRadians(lat1)) * Math.sin(Math.toRadians(lat2))
				+ Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) * Math.cos(Math.toRadians(theta));
		dist = Math.acos(dist);
		dist = Math.toDegrees(dist);
		dist = dist * 60 * 1.1515;
		dist = dist * 1.609344; // convert to kilometers
		dist = Math.round(dist);
		return (int) dist;
	}
}
