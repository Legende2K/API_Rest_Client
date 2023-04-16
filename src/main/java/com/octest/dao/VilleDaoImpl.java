package com.octest.dao;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.octest.beans.Ville;

public class VilleDaoImpl implements VilleDao {
	private static final String API_URL = "http://localhost:8181/ville";

	private Ville jsonToVille(JSONObject jsonObject) throws JSONException {
		Ville ville = new Ville();
		ville.setCodeCommune(jsonObject.getString("codeCommune"));
		ville.setCodePostal(jsonObject.getString("codePostal"));
		ville.setNomCommune(jsonObject.getString("nomCommune"));
		ville.setLibelleAcheminement(jsonObject.getString("libelleAcheminement"));
		ville.setLigne(jsonObject.getString("ligne"));
		ville.setLatitude(jsonObject.getString("latitude"));
		ville.setLongitude(jsonObject.getString("longitude"));

		return ville;
	}

	private String villeToJson(Ville ville) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("codeCommune", ville.getCodeCommune());
		jsonObject.put("nomCommune", ville.getNomCommune());
		jsonObject.put("codePostal", ville.getCodePostal());
		jsonObject.put("libelleAcheminement", ville.getLibelleAcheminement());
		jsonObject.put("ligne", ville.getLigne());
		jsonObject.put("latitude", ville.getLatitude());
		jsonObject.put("longitude", ville.getLongitude());

		return jsonObject.toString();
	}

	@Override
	public List<Ville> getVilles() {
		try {
			URL url = new URL(API_URL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

			String output;
			StringBuilder response = new StringBuilder();
			while ((output = br.readLine()) != null) {
				response.append(output);
			}

			conn.disconnect();

			JSONArray jsonArray = new JSONArray(response.toString());
			List<Ville> villes = new ArrayList<>();
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jsonObject = jsonArray.getJSONObject(i);
				Ville ville = jsonToVille(jsonObject);
				villes.add(ville);
			}
			return villes;
		} catch (IOException | JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Ville getVille(String codeCommune) {
		try {
			String urlStr = API_URL + "?codeCommune=" + codeCommune;
			URL url = new URL(urlStr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

			String output;
			StringBuilder response = new StringBuilder();
			while ((output = br.readLine()) != null) {
				response.append(output);
			}

			conn.disconnect();

			JSONArray jsonArray = new JSONArray(response.toString());
			Ville ville = jsonToVille(jsonArray.getJSONObject(0));

			return ville;
		} catch (IOException | JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<List<Ville>> getVillesBy50(List<Ville> villes) {
		List<List<Ville>> result = new ArrayList<>();
		int size = villes.size();
		int i = 0;
		while (i < size) {
			result.add(villes.subList(i, Math.min(i + 50, size)));
			i += 50;
		}
		return result;
	}

	@Override
	public void updateVille(Ville ville) {
		try {
			String urlStr = API_URL;
			URL url = new URL(urlStr);
			String villeJson = villeToJson(ville);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("PUT");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setDoOutput(true);

			OutputStream os = conn.getOutputStream();
			os.write(villeJson.getBytes());
			os.flush();

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}

			conn.disconnect();
		} catch (IOException | JSONException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void deleteVille(String codeCommune) {
	    try {
	        String urlStr = API_URL + "?codeCommune=" + codeCommune;
	        URL url = new URL(urlStr);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("DELETE");
	        conn.setRequestProperty("Accept", "application/json");

	        if (conn.getResponseCode() != 200) {
	            throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
	        }

	        conn.disconnect();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	}



}
