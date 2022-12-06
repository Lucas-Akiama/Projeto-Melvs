var database = require("../database/config");

function buscarUltimasMedidas(idArmazem, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == "producao") {
        instrucaoSql = `
        select top ${limite_linhas} 
            temperatura1 as temperatura,
            umidade1 as umidade,
            FORMAT(dtLeitura,'HH:mm:ss') as momento_grafico, fkSensor 
            from leitura where fkSensor = ${idArmazem}
            order by idLeitura desc;`;
    } else if (process.env.AMBIENTE_PROCESSO == "desenvolvimento") {
        instrucaoSql = `
        select temperatura1 as temperatura, umidade1 as umidade,
            DATE_FORMAT(dtLeitura,'%H:%i') as momento_grafico, fkSensor 
            from leitura where fkSensor = ${idArmazem}
            order by idLeitura desc limit ${limite_linhas};`;
    } else {
        console.log("\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n");
        return
    }

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoReal(idArmazem) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == "producao") {
        instrucaoSql = `
            select top 1 
                temperatura1 as temperatura,
                umidade1 as umidade,
                convert (varchar, dtLeitura, 108) as momento_grafico, fkSensor 
                from leitura where fkSensor = ${idArmazem}
                order by idLeitura desc;`;

    } else if (process.env.AMBIENTE_PROCESSO == "desenvolvimento") {
        instrucaoSql = `
        select temperatura1 as temperatura, umidade1 as umidade,
            DATE_FORMAT(dtLeitura,'%H:%i') as momento_grafico, fkSensor 
            from leitura where fkSensor = ${idArmazem}
            order by idLeitura desc limit 1;`;
    } else {
        console.log("\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n");
        return
    }

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal
}
