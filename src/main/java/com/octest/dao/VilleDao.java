package com.octest.dao;

import java.util.List;

import com.octest.beans.Ville;

public interface VilleDao {
    List<Ville> getVilles();
    
    List<List<Ville>> getVillesBy50(List<Ville> villes);

	Ville getVille(String codeCommune);
	
	void updateVille(Ville ville);

	void deleteVille(String codeCommune);
}

