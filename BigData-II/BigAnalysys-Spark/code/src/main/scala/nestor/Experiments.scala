package main.scala.nestor

import org.apache.spark.SparkContext
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

import scala.util.{Failure, Success, Try}

object Experiments {
  def execClassifiers(sc: SparkContext, train: RDD[LabeledPoint], test: RDD[LabeledPoint]): Unit = {
    printf("model,accuracy,auc\n")

    val rfResults = Experiments.execClassifier(Classifiers.RF(train, test))
    if (rfResults.isDefined)
      printf("RF,%s,%s\n", rfResults.get._1, rfResults.get._2)
    else
      println("RF,,,")

    val svmResults = Experiments.execClassifier(Classifiers.svmSGD(train, test))
    if (svmResults.isDefined)
      printf("SVM,%s,%s\n", svmResults.get._1, svmResults.get._2)
    else
      println("SVM,,,")

    val decisionTreeResults = Experiments.execClassifier(Classifiers.decisionTree(train, test))
    if (decisionTreeResults.isDefined)
      printf("decisionTree,%s,%s\n", decisionTreeResults.get._1, decisionTreeResults.get._2)
    else
      println("decisionTree,,,")

    val pcardResults = Experiments.execClassifier(Classifiers.pcard(sc, train, test))
    if (pcardResults.isDefined)
      printf("pcard,%s,%s\n", pcardResults.get._1, pcardResults.get._2)
    else
      println("pcard,,,")

    val gbtsResults = Experiments.execClassifier(Classifiers.gbt(train, test))
    if (gbtsResults.isDefined)
      printf("gbts,%s,%s\n", gbtsResults.get._1, gbtsResults.get._2)
    else
      println("gbts,,,")
  }

  def execClassifier[A](f: => A): Option[A] = Try {
    f
  } match {
    case Success(x) => Some(x)
    case Failure(e) => e.printStackTrace()
      print(e.getClass.toString + ": ")
      println(e.getMessage)
      e.getStackTrace.foreach(l => println("\t" + l))
      None
  }

  def basicExperiments(sc: SparkContext, pathTrain: String, pathTest: String, train: RDD[LabeledPoint],
                       test: RDD[LabeledPoint]): Unit = {
    println("Original dataset")
    Util.analyzeClassBalance(train)
    Experiments.execClassifiers(sc, train, test)

    println("Undersampling")
    val undersampledTrain = Sampling.RUS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0")
    Util.analyzeClassBalance(undersampledTrain)
    Experiments.execClassifiers(sc, undersampledTrain, test)

    println("Oversampling")
    val oversampledTrain = Sampling.ROS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0")
    Util.analyzeClassBalance(oversampledTrain)
    Experiments.execClassifiers(sc, oversampledTrain, test)

    println("ClearNoise.HMEBD")
    val HMEBDTrain = ClearNoise.HMEBD(train)
    Util.analyzeClassBalance(HMEBDTrain)
    Experiments.execClassifiers(sc, HMEBDTrain, test)

    println("ClearNoise.HTEBD")
    val HTEBDTrain = ClearNoise.HTEBD(train)
    Util.analyzeClassBalance(HTEBDTrain)
    Experiments.execClassifiers(sc, HTEBDTrain, test)

    println("ClearNoise.ENNBD")
    val ENNBDTrain = ClearNoise.ENNBD(train)
    Util.analyzeClassBalance(ENNBDTrain)
    Experiments.execClassifiers(sc, ENNBDTrain, test)

    println("ClearNoise.NCNEdit")
    val NCNEditTrain = ClearNoise.NCNEdit(train)
    Util.analyzeClassBalance(NCNEditTrain)
    Experiments.execClassifiers(sc, NCNEditTrain, test)

    println("Discretization.EWD")
    val (discretizedTrain, discretizedTest) = Discretization.EWD(train, test)
    Util.analyzeClassBalance(discretizedTrain)
    Experiments.execClassifiers(sc, discretizedTrain, discretizedTest)

    println("FeatureSelection.pca")
    val (pcaTrain, pcaTest) = FeatureSelection.pca(train, test)
    Util.analyzeClassBalance(pcaTrain)
    Experiments.execClassifiers(sc, pcaTrain, pcaTest)

    println("InstanceSelection.FCNN")
    val FCNNTrain = InstanceSelection.FCNN(train)
    Util.analyzeClassBalance(FCNNTrain)
    Experiments.execClassifiers(sc, FCNNTrain, test)

    println("InstanceSelection.RMHC")
    val RMHCTrain = InstanceSelection.RMHC(train)
    Util.analyzeClassBalance(RMHCTrain)
    Experiments.execClassifiers(sc, RMHCTrain, test)
  }

  def finCorrectOverRate(sc: SparkContext, pathTrain: String): Unit = {
    for (x <- 0d to 100d by 5) {
      println("rate: " + x)
      val oversampledTrain = Sampling.ROS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0", rate = x)
      Util.analyzeClassBalance(oversampledTrain)
    }
  }

  def chooseBestBalancedDataset(sc: SparkContext, pathTrain: String, pathTest: String, train: RDD[LabeledPoint],
                                test: RDD[LabeledPoint]): Unit = {
    println("Undersampling")
    val undersampledTrain = Sampling.RUS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0")
    Util.analyzeClassBalance(undersampledTrain)
    Experiments.execClassifiers(sc, undersampledTrain, test)

    println("Oversampling 50")
    val oversampled50Train = Sampling.ROS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0", rate = 50.0)
    Util.analyzeClassBalance(oversampled50Train)
    Experiments.execClassifiers(sc, oversampled50Train, test)

    println("Oversampling 100")
    val oversampled100Train = Sampling.ROS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0", rate = 100.0)
    Util.analyzeClassBalance(oversampled100Train)
    Experiments.execClassifiers(sc, oversampled100Train, test)
  }

  def oversampled50_ENNBD_PCA_RMHC(sc: SparkContext, pathTrain: String, pathTest: String,
                                   test: RDD[LabeledPoint]): Unit = {
    println("Oversampling 50")
    val oversampled50 = Sampling.ROS(sc, path = pathTrain, majClass = "1.0", minClass = "0.0", rate = 50.0)
    Util.analyzeClassBalance(oversampled50)

    println("ClearNoise.ENNBD")
    val oversampled50_ENNBD = ClearNoise.ENNBD(oversampled50)
    Util.analyzeClassBalance(oversampled50_ENNBD)

    println("FeatureSelection.pca")
    val (oversampled50_ENNBD_PCA, pcaTest) = FeatureSelection.pca(oversampled50_ENNBD, test)
    Util.analyzeClassBalance(oversampled50_ENNBD_PCA)

    println("InstanceSelection.RMHC")
    val oversampled50_ENNBD_PCA_RMHC = InstanceSelection.RMHC(oversampled50_ENNBD_PCA)
    Util.analyzeClassBalance(oversampled50_ENNBD_PCA_RMHC)

    Experiments.execClassifiers(sc, oversampled50_ENNBD_PCA_RMHC, pcaTest)
  }

  def RMHC_ENNBD_oversampled100(sc: SparkContext, pathTrain: String, pathTest: String, train: RDD[LabeledPoint],
                                test: RDD[LabeledPoint]): Unit = {
    println("InstanceSelection.RMHC")
    val rmhc = InstanceSelection.RMHC(train)
    Util.analyzeClassBalance(rmhc)

    println("ClearNoise.ENNBD")
    val rmhc_ENNBD = ClearNoise.ENNBD(rmhc)
    Util.analyzeClassBalance(rmhc_ENNBD)

    println("Oversampling 100")
    val rmhc_ENNBD_oversampled100 = Sampling.ROS_data(sc, train = rmhc_ENNBD, majClass = 1.0, minClass = 0.0, rate = 100.0)
    Util.analyzeClassBalance(rmhc_ENNBD_oversampled100)

    Experiments.execClassifiers(sc, rmhc_ENNBD_oversampled100, test)
  }

  def maj_FCNN_NCNEdit_oversampled100(sc: SparkContext, pathTrain: String, pathTest: String, train: RDD[LabeledPoint],
                                      test: RDD[LabeledPoint]): Unit = {

    val positive = train.filter(point => point.label == 0.0).cache
    val negative = train.filter(point => point.label == 1.0).cache

    println("InstanceSelection.FCNN")
    val negativeFCNN = InstanceSelection.FCNN(negative)
    Util.analyzeClassBalance(negativeFCNN)

    println("ClearNoise.NCNEdit")
    val negative_FCNN_NCNEdit = ClearNoise.NCNEdit(negativeFCNN)
    Util.analyzeClassBalance(negative_FCNN_NCNEdit)

    println("Combine positive and negative")
    val newTrain = positive.union(negative_FCNN_NCNEdit)
    Util.analyzeClassBalance(newTrain)

    println("Oversampling 100")
    val maj_FCNN_NCNEdit_oversampled100 = if (positive.count() > negative_FCNN_NCNEdit.count())
      Sampling.ROS_data(sc, train = newTrain, majClass = 0.0, minClass = 1.0, rate = 100.0)
    else
      Sampling.ROS_data(sc, train = newTrain, majClass = 1.0, minClass = 0.0, rate = 100.0)

    Util.analyzeClassBalance(maj_FCNN_NCNEdit_oversampled100)

    Experiments.execClassifiers(sc, maj_FCNN_NCNEdit_oversampled100, test)
  }

  def RMHC_oversampled100(sc: SparkContext, pathTrain: String, pathTest: String, train: RDD[LabeledPoint],
                          test: RDD[LabeledPoint]): Unit = {
    println("InstanceSelection.RMHC")
    val rmhc = InstanceSelection.RMHC(train)
    Util.analyzeClassBalance(rmhc)

    println("Oversampling 100")
    val rmhc_oversampled100 = Sampling.ROS_data(sc, train = rmhc, majClass = 1.0, minClass = 0.0, rate = 100.0)
    Util.analyzeClassBalance(rmhc_oversampled100)

    Experiments.execClassifiers(sc, rmhc_oversampled100, test)
  }
}
