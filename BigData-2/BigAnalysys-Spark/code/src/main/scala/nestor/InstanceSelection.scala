package main.scala.nestor

import org.apache.spark.mllib.feature.{FCNN_MR, RMHC_MR, SSMASFLSDE_MR}
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

object InstanceSelection {

  def FCNN(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    new FCNN_MR(data, k = 3).runPR.persist
  }

  def RMHC(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    val p = 0.1 // Percentage of instances (max 1.0)
    val it = 100 // Number of iterations
    val k = 3 // Number of neighbors
    new RMHC_MR(data, p, it, k, seed = 0).runPR.persist
  }

  def SSMASFLSDE(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    new SSMASFLSDE_MR(data).runPR.persist
  }
}
