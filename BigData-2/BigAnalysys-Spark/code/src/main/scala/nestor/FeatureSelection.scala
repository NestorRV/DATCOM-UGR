package main.scala.nestor

import org.apache.spark.mllib.feature.PCA
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

object FeatureSelection {
  def pca(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (RDD[LabeledPoint], RDD[LabeledPoint]) = {
    val pca = new PCA(k = 5).fit(train.map(_.features))

    val projectedTrain = train.map(p => p.copy(features = pca.transform(p.features)))
    val projectedTest = test.map(p => p.copy(features = pca.transform(p.features)))

    (projectedTrain, projectedTest)
  }
}
