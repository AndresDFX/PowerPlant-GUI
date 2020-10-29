// Ocultar contenedor de resultados
$(".container_results").hide();

// Inicializar Handsotable
var container = document.getElementById("demanda_cliente");
let headers_hot = colHeadersTable(12);
// Tabla para demanda
var hot = new Handsontable(container, {
  startRows: 10,
  startCols: 12,
  rowHeaders: true,
  colHeaders: headers_hot,
  filters: false,
  dropdownMenu: false,
  width: "100%",
  height: 300,
  manualColumnResize: true,
  manualRowResize: true,
  colWidths: 100,
});

// Enviar los datos al servidor
$("#send").click(function () {
  // Limpiar campos nulls de handsontable
  var gridData = hot.getData();
  var cleanedGridData = {};

  $.each(gridData, function (rowKey, object) {
    if (!hot.isEmptyRow(rowKey)) {
      let row = object.filter((elem) => elem);
      cleanedGridData[rowKey] = row;
    }
  });

  // Capturar los datos
  let data = {
    cp: $("#cp").val(), // Capacidad de produccion
    cc: $("#cc").val(), // Costo de produccion
    n: $("#nd").val(), // Numero de dias
    s: $("#nc").val(), // Numero de clientes
    d: cleanedGridData, // Demanda de energia diaria por cliente
  };

  console.log("Parametros", data);

  // Enviar Petición
  $.ajax({
    url: "/model",
    type: "POST",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify(data),
    success: function (data) {
      console.log(data);
      if (data.message) {
        alert("Insatisfactible!");
      } else {
        // Matriz de datos
        let mw = data.data.MW;
        // Inicializar tabla de resultados
        let dias = $("#nd").val();
        initTableResults(dias, mw);
        // Mostrar costo minimo
        $("#costo").text(data.data.costo);
        // Mostrar contenedor de resultados
        $(".container_results").show();
        // Mensaje
        alert("Ver resultados!");
      }
    },
    error: function () {
      alert("Datos Invalidos");
    },
  });
});
$("#file_dzn").click(function () {
  const options = {
    method: "GET",
  };

  fetch("/model", options)
    .then((res) => {
      return res.blob();
    })
    .then((blob) => {
      download(blob, "Datos.dzn");
    })
    .catch((err) => console.log(err));
});

function initTableResults(dias, data) {
  // Tabla para resultados
  var container_results = document.getElementById("resultados");

  let headers = colHeadersTable(dias);

  var hot_results = new Handsontable(container_results, {
    startRows: 3,
    startCols: dias,
    rowHeaders: ["CN", "CH", "CT"],
    rowWidths: 100,
    colHeaders: headers,
    filters: false,
    dropdownMenu: false,
    width: "100%",
    height: 130,
    manualColumnResize: true,
    manualRowResize: true,
    colWidths: 100,
  });

  // Cargar datos
  hot_results.loadData(data);
}

function colHeadersTable(n) {
  let result = [];
  for (var i = 1; i <= n; i++) {
    result.push(`Dia ${i}`);
  }
  return result;
}
