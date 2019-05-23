package main.scala.nestor

import org.apache.spark.SparkContext
import org.apache.spark.mllib.classification.SVMWithSGD
import org.apache.spark.mllib.classification.kNN_IS.kNN_IS
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.tree.configuration.BoostingStrategy
import org.apache.spark.mllib.tree.{DecisionTree, GradientBoostedTrees, PCARD, RandomForest}
import org.apache.spark.rdd.RDD

object Classifiers {

  def RF(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (Double, Double) = {
    // Empty categoricalFeaturesInfo indicates all features are continuous.
    val rf = RandomForest.trainClassifier(train, numClasses = 2, categoricalFeaturesInfo = Map[Int, Int](),
      numTrees = 80, featureSubsetStrategy = "auto", impurity = "gini", maxDepth = 8, maxBins = 32, seed = 0)

    // Evaluate model on test instances and compute test error
    val predictions: RDD[(Double, Double)] = test.map { point =>
      val prediction = rf.predict(point.features)
      (point.label, prediction)
    }

    (Util.getAccuracy(predictions), Util.auc(predictions))
  }

  def svmSGD(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (Double, Double) = {
    val svmSGD = SVMWithSGD.train(train, numIterations = 100)
    // Clear the default threshold.
    svmSGD.clearThreshold()

    val predictions = test.map { point =>
      val prediction = svmSGD.predict(point.features)
      (prediction, point.label)
    }

    (Util.getAccuracy(predictions), Util.auc(predictions))
  }

  def pcard(sc: SparkContext, train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (Double, Double) = {
    val pcard = PCARD.train(train, nTrees = 100, cuts = 5)
    val labels = pcard.predict(test)
    val predictions = sc.parallelize(labels).zipWithIndex.map { case (v, k) => (k, v) }
      .join(test.zipWithIndex.map { case (v, k) => (k, v.label) }).map(_._2)
    (Util.getAccuracy(predictions), Util.auc(predictions))
  }

  def decisionTree(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (Double, Double) = {
    val modelDT = DecisionTree.trainClassifier(train, numClasses = 2, categoricalFeaturesInfo = Map[Int, Int](),
      impurity = "gini", maxDepth = 8, maxBins = 32)

    val predictions: RDD[(Double, Double)] = test.map { point =>
      val prediction = modelDT.predict(point.features)
      (point.label, prediction)
    }

    (Util.getAccuracy(predictions), Util.auc(predictions))
  }

  def knn_IS(sc: SparkContext, train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (Double, Double) = {
    // distanceType = 2 means euclidean
    val knn = kNN_IS.setup(train, test, k = 3, distanceType = 2, numClass = 2, numFeatures = train.first().features.size,
      numPartitionMap = 60, numReduces = 5, numIterations = 50, maxWeight = 10.0)
    val predictions: RDD[(Double, Double)] = knn.predict(sc)

    (Util.getAccuracy(predictions), Util.auc(predictions))
  }

  def gbt(train: RDD[LabeledPoint], test: RDD[LabeledPoint]): (Double, Double) = {
    // Train a GradientBoostedTrees model
    val boostingStrategy = BoostingStrategy.defaultParams("Classification")
    boostingStrategy.numIterations = 100
    boostingStrategy.treeStrategy.numClasses = 2
    boostingStrategy.treeStrategy.maxDepth = 5
    boostingStrategy.treeStrategy.categoricalFeaturesInfo = Map[Int, Int]()

    val model = GradientBoostedTrees.train(train, boostingStrategy)

    // Evaluate model on test instances and compute test error
    val predictions = test.map { point =>
      val prediction = model.predict(point.features)
      (point.label, prediction)
    }

    (Util.getAccuracy(predictions), Util.auc(predictions))
  }
}
