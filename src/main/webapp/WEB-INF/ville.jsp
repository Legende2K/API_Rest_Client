<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Villes de france</title>
<style>
body {
	font-family: Arial, sans-serif;
}

.tab {
	overflow: hidden;
	border: 1px solid #ccc;
	background-color: #f1f1f1;
}

.tab button {
	background-color: inherit;
	float: left;
	border: none;
	outline: none;
	cursor: pointer;
	padding: 14px 16px;
	transition: 0.3s;
}

.tab button:hover {
	background-color: #ddd;
}

.tab button.active {
	background-color: #ccc;
}

.tabcontent {
	background-color: #f9f9f9;
	padding: 20px;
	border: 1px solid #ccc;
}

form {
	display: flex;
	flex-direction: row;
	align-items: center;
	justify-content: center;
}

label {
	margin: 10px;
}

span {
	margin-right: 10px;
	font-weight: bold;
}

select, input[type="submit"] {
	padding: 10px;
	margin: 10px 0;
	border-radius: 5px;
	border: none;
	background-color: #e3e3e3;
	color: #444;
	font-size: 16px;
}

input[type="submit"]{
	margin-left: 10px;
}

input[type="submit"]:hover {
	background-color: #ddd;
	cursor: pointer;
}

p {
	margin-top: 20px;
	font-size: 18px;
}

.pagination {
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 20px 0;
}

.pagination button {
	padding: 10px;
	margin: 0 5px;
	border-radius: 5px;
	border: none;
	background-color: #e3e3e3;
	color: #444;
	font-size: 16px;
}

.pagination button:hover {
	background-color: #ddd;
	cursor: pointer;
}

table {
	border-collapse: collapse;
	width: 100%;
}

th, td {
	text-align: left;
	padding: 8px;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

th {
	background-color: black;
	color: white;
}

.input-form {
	padding: 10px;
	margin: 10px 0;
	border-radius: 5px;
	border: 1px solid #ccc;
	background-color: #f9f9f9;
	color: #444;
	font-size: 16px;
}

.input-form:focus {
	outline: none;
	border-color: #aaa;
}

.pagination button, .form-button {
	padding: 10px;
	margin: 10px;
	border-radius: 5px;
	border: none;
	background-color: #e3e3e3;
	color: #444;
	font-size: 16px;
}

.pagination button:hover, .form-button:hover {
	background-color: #ddd;
	cursor: pointer;
}

#editVilleForm{
	display: none;
}
</style>
</head>
<body>

	<div class="tab">
		<button class="tablinks" onclick="openTab(event, 'Tab1')" id="defaultOpen">Calculer
			la distance entre 2 villes</button>
		<button class="tablinks" onclick="openTab(event, 'Tab2')">Editer la liste des villes</button>
	</div>

	<div id="Tab1" class="tabcontent">
		<h2>Liste des villes</h2>
		<form method="POST">
			<input type="hidden" name="action" value="calculateDistance" />
			<input type="hidden" id="tab1-form-currentTab" name="currentTab" value="Tab1" />
			<label for="ville1">Ville 1:</label> <select name="ville1"
				id="ville1">
				<c:forEach items="${villes}" var="ville">
					<option value="${ville.codeCommune}">${ville.nomCommune}</option>
				</c:forEach>
			</select> <br /> <label for="ville2">Ville 2:</label> <select name="ville2"
				id="ville2">
				<c:forEach items="${villes}" var="ville">
					<option value="${ville.codeCommune}">${ville.nomCommune}</option>
				</c:forEach>
			</select> <br /> <input name="CalculDistance" type="submit" value="Calculer distance" />
		</form>
		<c:if test="${not empty distance}">
			<p>La distance entre ${ville1.nomCommune} et ${ville2.nomCommune}
				est de ${distance} km.</p>
		</c:if>
	</div>

	<div id="Tab2" class="tabcontent">
		<h2>Liste des villes</h2>
		<div class="pagination">
			<form id="pagination-form" method="GET" action="VillesServlet">
				<input type="hidden" id="tab2-form-currentTab" name="currentTab" value="Tab2" />
				<input type="hidden" id="page" name="page" value="${page}" />
			</form>
			<button onclick="minus10Pages()">-10 pages</button>
			<button onclick="previousPage()">Précédent</button>
			<button onclick="nextPage()">Suivant</button>
			<button onclick="plus10Pages()">+10 pages</button>
		</div>
		<form id="editVilleForm" method="POST" action="VillesServlet">
			<input type="hidden" id="tab2-form-currentTab" name="currentTab" value="Tab2" />
			<input type="hidden" name="action" value="editVilles" />
			<input type="hidden" id="editCodeCommune" name="codeCommune">
			<label for="editNomCommune">Nom Commune:</label> 
			<span id="currentNomCommune"></span> 
			<input type="text" id="editNomCommune" name="nomCommune" placeholder="Entrez un nouveau nom " class="input-form"> <br>
			<label for="editLigne">Ligne:</label> 
			<input type="text" id="editLigne" name="ligne" placeholder="Entrez une nouvelle ligne" class="input-form"> <br>
			<input name="Modifier" type="submit" value="Modifier">
			<input name="Supprimer" type="submit" value="Supprimer">

		</form>

		<table id="villeTable">
			<thead>
				<tr>
					<th>Code commune</th>
					<th>Nom commune</th>
					<th>Code postal</th>
					<th>Libellé d'acheminement</th>
					<th>Ligne</th>
					<th>Latitude</th>
					<th>Longitude</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${villesBy50[page]}" var="ville">
					<tr>
						<td>${ville.codeCommune}</td>
						<td>${ville.nomCommune}</td>
						<td>${ville.codePostal}</td>
						<td>${ville.libelleAcheminement}</td>
						<td>${ville.ligne}</td>
						<td>${ville.latitude}</td>
						<td>${ville.longitude}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>

	<script>
		function openTab(evt, tabName) {
			// Déclaration des variables
			var i, tabcontent, tablinks;

			// Cacher tous les contenus des onglets
			tabcontent = document.getElementsByClassName("tabcontent");
			for (i = 0; i < tabcontent.length; i++) {
				tabcontent[i].style.display = "none";
			}

			// Enlever la classe "active" de tous les boutons d'onglets
			tablinks = document.getElementsByClassName("tablinks");
			for (i = 0; i < tablinks.length; i++) {
				tablinks[i].className = tablinks[i].className.replace(
						" active", "");
			}

			// Afficher le contenu de l'onglet sélectionné et ajouter la classe "active" au bouton correspondant
			document.getElementById(tabName).style.display = "block";
			evt.currentTarget.className += " active";
			document.getElementById("tab1-form-currentTab").value = tabName;
		    document.getElementById("tab2-form-currentTab").value = tabName;

		}


	  // fonction pour aller à la page précédente
	  function previousPage() {
	    if (${page} > 1) {
	      document.getElementById("page").value = ${page} - 1;
	      document.getElementById("pagination-form").submit();
	    }
	  }
	  
	  // fonction pour aller à la page suivante
	  function nextPage() {
	    document.getElementById("page").value = ${page} + 1;
	    document.getElementById("pagination-form").submit();
	  }
	  
	  // fonction pour aller à une page spécifique
	  function goToPage(pageNumber) {
	    document.getElementById("page").value = pageNumber;
	    document.getElementById("pagination-form").submit();
	  }
	  
	  // fonction pour aller à la page précédente de 10 pages
	  function minus10Pages() {
	    if (${page} > 10) {
	      document.getElementById("page").value = ${page} - 10;
	      document.getElementById("pagination-form").submit();
	    } else {
	      document.getElementById("page").value = 1;
	      document.getElementById("pagination-form").submit();
	    }
	  }
	  
	  // fonction pour aller à la page suivante de 10 pages
	  function plus10Pages() {
	    document.getElementById("page").value = ${page} + 10;
	    document.getElementById("pagination-form").submit();
	  }
	  
	  var villesData = {
		        <c:forEach items="${villesBy50[page]}" var="ville" varStatus="loop">
		            '${ville.codeCommune}': {
		                codeCommune: '${ville.codeCommune}',
		                nomCommune: '${ville.nomCommune}',
		                ligne: '${ville.ligne}'
		            }<c:if test="${not loop.last}">,</c:if>
		        </c:forEach>
		    }; 
	  
	  document.getElementById("villeTable").addEventListener("click", function(event) {
		    var target = event.target;
		    while (target.tagName !== "TR") {
		        if (target.tagName === "TABLE") {
		            return; 
		        }
		        target = target.parentNode; 
		    }

		    var codeCommune = target.children[0].textContent;
		    editVille(codeCommune);
		});

		function editVille(codeCommune) {
		    var ville = villesData[codeCommune];
		    document.getElementById("editVilleForm").style.display = 'flex';
		    document.getElementById("editCodeCommune").value = ville.codeCommune;
		    document.getElementById("currentNomCommune").textContent = ville.nomCommune;
		    document.getElementById("editLigne").value = ville.ligne;
		}
		
		// Sélectionner le 2e onglet par défaut
		<c:choose>
			<c:when test="${not empty currentTab}">
				document.getElementById("${currentTab}").click();
			</c:when>
			<c:otherwise>
				document.getElementById("defaultOpen").click();
			</c:otherwise>
		</c:choose>
		

	</script>
</body>
</html>