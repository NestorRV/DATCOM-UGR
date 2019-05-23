package main.scala.nestor

import breeze.numerics.sqrt
import org.apache.spark.mllib.evaluation.{BinaryClassificationMetrics, MulticlassMetrics}
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

object Util {

  def analyzeClassBalance(train: RDD[LabeledPoint]): Unit = {
    //Class balance
    val classInfo: collection.Map[Double, Long] = train.map(lp => (lp.label, 1L)).reduceByKey(_ + _).collectAsMap()
    for ((k, v) <- classInfo) println(k + " " + v)
  }

  def analyzeMissing(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): Unit = {
    var trainNACount = 0
    train.foreach(value => if (value == null) trainNACount += 1)
    println("trainNACount: " + trainNACount)

    var testNACount = 0
    test.foreach(value => if (value == null) testNACount += 1)
    println("testNACount: " + testNACount)
  }

  def getAccuracy(predictions: RDD[(Double, Double)]): Double = {
    new MulticlassMetrics(predictions).accuracy
  }

  def geometricMean(predictions: RDD[(Double, Double)]): Double = {
    val metrics = new MulticlassMetrics(predictions)
    val tpr = metrics.truePositiveRate(0.0)
    val tnr = metrics.truePositiveRate(1.0)

    sqrt(tpr * tnr)
  }

  def auc(predictions: RDD[(Double, Double)]): Double = {
    new BinaryClassificationMetrics(predictions).areaUnderROC
  }
}
