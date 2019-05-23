package main.scala.nestor

import org.apache.spark.mllib.linalg.Vectors
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}

object Main {
  def main(arg: Array[String]) {
    val sc = new SparkContext(new SparkConf().setAppName("PFBD2"))
    val pathTrain = arg(0)
    val pathTest = arg(1)

    val train: RDD[LabeledPoint] = sc.textFile(pathTrain, minPartitions = 60).map { line =>
      val array = line.split(",")
      val arrayDouble = array.map(f => f.toDouble)
      val featureVector = Vectors.dense(arrayDouble.init)
      val label = arrayDouble.last
      LabeledPoint(label, featureVector)
    }.persist

    val test: RDD[LabeledPoint] = sc.textFile(pathTest, minPartitions = 60).map { line =>
      val array = line.split(",")
      val arrayDouble = array.map(f => f.toDouble)
      val featureVector = Vectors.dense(arrayDouble.init)
      val label = arrayDouble.last
      LabeledPoint(label, featureVector)
    }.persist

    // Util.analyzeMissing(train, test)
    // Experiments.basicExperiments(sc, pathTrain, pathTest, train, test)
    // Experiments.finCorrectOverRate(sc, pathTrain)
    // Experiments.chooseBestBalancedDataset(sc, pathTrain, pathTest, traxin, test)
    // Experiments.oversampled50_ENNBD_PCA_RMHC(sc, pathTrain, pathTest, test)
    // Experiments.RMHC_ENNBD_oversampled100(sc, pathTrain, pathTest, train, test)
    // Experiments.maj_FCNN_NCNEdit_oversampled100(sc, pathTrain, pathTest, train, test)

    Experiments.RMHC_oversampled100(sc, pathTrain, pathTest, train, test)
  }
}
