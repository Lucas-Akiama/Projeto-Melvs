var express = require("express");
var router = express.Router();

var avisoController = require("../controllers/avisoController");

router.get("/", function (req, res) {
    avisoController.testar(req, res);
});

router.get("/listar", function (req, res) {
    avisoController.listar(req, res);
});

router.get("/atualizarEmpresa/:id", function (req, res) {
    avisoController.atualizarEmpresa(req, res);
});

router.get("/atualizarFuncionario/:id", function (req, res) {
    avisoController.atualizarFuncionario(req, res);
});

router.get("/atualizarArmazem", function (req, res) {
    avisoController.atualizarArmazem(req, res);
});


router.get("/listar/:idUsuario", function (req, res) {
    avisoController.listarPorUsuario(req, res);
});

router.get("/pesquisar/:descricao", function (req, res) {
    avisoController.pesquisarDescricao(req, res);
});

router.post("/cadastrarEmpresa", function (req, res) {
    avisoController.cadastrarEmpresa(req, res);
});

router.post("/cadastrarEmpresaAdmin/:id", function (req, res) {
    avisoController.cadastrarEmpresaAdmin(req, res);
});

router.post("/cadastrarFuncionario", function (req, res) {
    avisoController.cadastrarFuncionario(req, res);
});

router.post("/cadastrarUsuario", function (req, res) {
    avisoController.cadastrarUsuario(req, res);
});

router.post("/publicar/:idUsuario", function (req, res) {
    avisoController.publicar(req, res);
});

router.put("/editar/:idAviso", function (req, res) {
    avisoController.editar(req, res);
});

router.delete("/deletar/:idAviso", function (req, res) {
    avisoController.deletar(req, res);
});

module.exports = router;