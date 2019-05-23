package main.scala.nestor

import org.apache.spark.mllib.feature._
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

object ClearNoise {

  def HMEBD(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    new HME_BD(data, nTrees = 100, k = 4, maxDepth = 10, seed = 0)
      .runFilter.persist
  }

  def HTEBD(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    // 0 = majority, 1 = consensus
    new HTE_BD(data, nTrees = 100, partitions = 4, vote = 0, k = 4, maxDepth = 10, seed = 0)
      .runFilter.persist
  }

  def ENNBD(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    new ENN_BD(data, k = 4).runFilter.persist
  }

  def NCNEdit(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    new NCNEdit_BD(data, k = 4).runFilter.persist
  }

  def RNG(data: RDD[LabeledPoint]): RDD[LabeledPoint] = {
    val order = true // Order of the graph (true = first, false = second)
    val selType = true // Selection type (true = edition, false = condensation)
    new RNG_BD(data, order, selType).runFilter.persist
  }
}
