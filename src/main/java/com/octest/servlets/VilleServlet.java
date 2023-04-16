package com.octest.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.octest.beans.Distance;
import com.octest.beans.Ville;
import com.octest.dao.VilleDao;
import com.octest.dao.VilleDaoImpl;

@WebServlet("/VillesServlet")
public class VilleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private VilleDao villeDao = new VilleDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Ville> villes = villeDao.getVilles();
        List<List<Ville>> villesBy50 = villeDao.getVillesBy50(villes);
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }
        request.setAttribute("villes", villes);
        request.setAttribute("villesBy50", villesBy50);
        request.setAttribute("page", page);
        request.getRequestDispatcher("/WEB-INF/ville.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String modifier = request.getParameter("Modifier");
        String supprimer = request.getParameter("Supprimer");
        String calculDistance = request.getParameter("CalculDistance");
        String currentTab = request.getParameter("currentTab");
        List<Ville> villes = villeDao.getVilles();
        if (currentTab == null) {
            currentTab = "Tab1";
        }
        request.setAttribute("currentTab", currentTab);
        if (modifier != null) {
            String codeCommune = request.getParameter("codeCommune");
            String nomCommune = request.getParameter("nomCommune");
            String ligne = request.getParameter("ligne");
            Ville ville = new Ville();
            ville.setCodeCommune(codeCommune);
            ville.setNomCommune(nomCommune);
            ville.setLigne(ligne);

            villeDao.updateVille(ville);
        } else if (supprimer != null) {
            String codeCommune = request.getParameter("codeCommune");
            villeDao.deleteVille(codeCommune);
        } else if (calculDistance != null) {
        	String codeCommune1 = request.getParameter("ville1");
            String codeCommune2 = request.getParameter("ville2");
            Ville ville1 = villeDao.getVille(codeCommune1);
            Ville ville2 = villeDao.getVille(codeCommune2);
        	int distance = Distance.distance(ville1, ville2);
            request.setAttribute("distance", distance);
            request.setAttribute("ville1", ville1);
            request.setAttribute("ville2", ville2);
            request.setAttribute("villes", villes);
            request.setAttribute("villeDao", villeDao);
            
        }
        this.doGet(request, response);
    }
}
