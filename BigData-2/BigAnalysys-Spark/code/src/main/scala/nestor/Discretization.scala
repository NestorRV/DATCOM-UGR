package main.scala.nestor

import org.apache.spark.mllib.feature.EqualWidthDiscretizer
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

object Discretization {

  def EWD(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (RDD[LabeledPoint], RDD[LabeledPoint]) = {
    val model = new EqualWidthDiscretizer(train, nBins = 25).calcThresholds()
    (model.discretize(train), model.discretize(test))
  }

}
