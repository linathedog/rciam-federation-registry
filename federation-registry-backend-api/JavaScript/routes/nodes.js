require("dotenv").config();
const { db } = require("../db");
var router = require("express").Router({ mergeParams: true });
const {adminAuth} = require('./authentication.js'); 

router.get("", adminAuth, (req, res, next) => {
  try {
    db.service
      .getAllNodes(req.params.tenant)
      .then((result) => {
        res.status(200).send(result ? result : []);
      })
      .catch((err) => {
        next(err);
      });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
