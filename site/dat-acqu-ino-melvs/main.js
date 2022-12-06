const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');
const sql = require('mssql');

const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

const HABILITAR_OPERACAO_INSERIR = true;

const AMBIENTE = 'desenvolvimento';

const serial = async (
    valoresUmidade1,
    valoresTemp1,
    // valoresUmidade2,
    // valoresTemp2,
    // valoresUmidade3,
    // valoresTemp3,
    // valoresUmidade4,
    // valoresTemp4,
    // valoresUmidade5,
    // valoresTemp5
) => {
    let poolBancoDados = ''

    if (AMBIENTE == 'desenvolvimento') {
        poolBancoDados = mysql.createPool(
            {
                host: 'localhost',
                user: 'insertGrupo6',
                password: '1234',
                database: 'melvs'
            }
        ).promise();
    } else if (AMBIENTE == 'producao') {
        console.log('Projeto rodando inserindo dados em nuvem. Configure as credenciais abaixo.');
    } else {
        throw new Error('Ambiente não configurado. Verifique o arquivo "main.js" e tente novamente.');
    }


    const portas = await serialport.SerialPort.list();
    const portaArduino = portas.find((porta) => porta.vendorId == 2341 && porta.productId == 43);
    if (!portaArduino) {
        throw new Error('O arduino não foi encontrado em nenhuma porta serial');
    }
    const arduino = new serialport.SerialPort(
        {
            path: portaArduino.path,
            baudRate: SERIAL_BAUD_RATE
        }
    );
    arduino.on('open', () => {
        console.log(`A leitura do arduino foi iniciada na porta ${portaArduino.path} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        console.log(data);
        const valores = data.split(';');
        const temp1 = parseFloat(valores[0]);
        const umidade1 = parseFloat(valores[1]);
        // const temp2 = parseFloat(valores[2]);
        // const umidade2 = parseFloat(valores[3]);
        // const temp3 = parseInt(valores[4]);
        // const umidade3 = parseInt(valores[5]);
        // const temp4 = parseInt(valores[6]);
        // const umidade4 = parseInt(valores[7]);
        // const temp5 = parseInt(valores[8]);
        // const umidade5= parseInt(valores[9]);

        valoresUmidade1.push(umidade1);
        valoresTemp1.push(temp1);
        // valoresUmidade2.push(umidade2);
        // valoresTemp2.push(temp2);
        // valoresUmidade3.push(umidade3);
        // valoresTemp3.push(temp3);
        // valoresUmidade4.push(umidade4);
        // valoresTemp4.push(temp4);
        // valoresUmidade5.push(umidade5);
        // valoresTemp5.push(temp5);

        if (HABILITAR_OPERACAO_INSERIR) {
            if (AMBIENTE == 'producao') {
                sqlquery = `INSERT INTO medida (dht11_umidade, dht11_temperatura, luminosidade, lm35_temperatura, chave, momento, fk_aquario) VALUES (${dht11Umidade}, ${dht11Temperatura}, ${luminosidade}, ${lm35Temperatura}, ${chave}, CURRENT_TIMESTAMP, 1)`;

                const connStr = "Server=servidor-acquatec.database.windows.net;Database=bd-acquatec;User Id=usuarioParaAPIArduino_datawriter;Password=#Gf_senhaParaAPI;";

                function inserirComando(conn, sqlquery) {
                    conn.query(sqlquery);
                    console.log("valores inseridos no banco: ", dht11Umidade + ", " + dht11Temperatura + ", " + luminosidade + ", " + lm35Temperatura + ", " + chave)
                }

                sql.connect(connStr)
                    .then(conn => inserirComando(conn, sqlquery))
                    .catch(err => console.log("erro! " + err));

            } else if (AMBIENTE == 'desenvolvimento') {

                await poolBancoDados.execute(
                    'INSERT INTO leitura (temperatura1, umidade1,fkSensor) VALUES (?,?,?)',
                    [temp1, umidade1, 1]

                );
                console.log("valores inseridos no banco: ", temp1 + ", " + umidade1)


            } else {
                throw new Error('Ambiente não configurado. Verifique o arquivo "main.js" e tente novamente.');
            }
        }
    });
    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

const servidor = (
    valoresUmidade1,
    valoresTemp1,
    // valoresUmidade2,
    // valoresTemp2,
    // valoresUmidade3,
    // valoresTemp3,
    // valoresUmidade4,
    // valoresTemp4,
    // valoresUmidade5,
    // valoresTemp5
) => {
    const app = express();
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });
    app.get('/sensores/dht11/umidade1', (_, response) => {
        return response.json(valoresUmidade1);
    });
    app.get('/sensores/dht11/temperatura1', (_, response) => {
        return response.json(valoresTemp1);
    });
    // app.get('/sensores/dht11/umidade2', (_, response) => {
    //     return response.json(valoresUmidade2);
    // });
    // app.get('/sensores/dht11/temperatura2', (_, response) => {
    //     return response.json(valoresTemp2);
    // });
    // app.get('/sensores/dht11/umidade3', (_, response) => {
    //     return response.json(valoresUmidade3);
    // });
    // app.get('/sensores/dht11/temperatura3', (_, response) => {
    //     return response.json(valoresTemp3);
    // });
    // app.get('/sensores/dht11/umidade4', (_, response) => {
    //     return response.json(valoresUmidade4);
    // });
    // app.get('/sensores/dht11/temperatura4', (_, response) => {
    //     return response.json(valoresTemp4);
    // });
    // app.get('/sensores/dht11/umidade5', (_, response) => {
    //     return response.json(valoresUmidade5);
    // });
    // app.get('/sensores/dht11/temperatura5', (_, response) => {
    //     return response.json(valoresTemp5);
    // });
}

(async () => {
    const valoresUmidade1 = [];
    const valoresTemp1 = [];
    // const valoresUmidade2 = [];
    // const valoresTemp2 = [];
    // const valoresUmidade3 = [];
    // const valoresTemp3 = [];
    // const valoresUmidade4 = [];
    // const valoresTemp4 = [];
    // const valoresUmidade5 = [];
    // const valoresTemp5 = [];
    await serial(
        valoresUmidade1,
        valoresTemp1,
        // valoresUmidade2,
        // valoresTemp2,
        // valoresUmidade3,
        // valoresTemp3,
        // valoresUmidade4,
        // valoresTemp4,
        // valoresUmidade5,
        // valoresTemp5
    );
    servidor(
        valoresUmidade1,
        valoresTemp1,
        // valoresUmidade2,
        // valoresTemp2,
        // valoresUmidade3,
        // valoresTemp3,
        // valoresUmidade4,
        // valoresTemp4,
        // valoresUmidade5,
        // valoresTemp5
    );
})();
