# From Stefan Schlager
#' convert an  SimpleITK image to an antsImage
#'
#' convert an  SimpleITK image to an antsImage
#' @param image object of class SimpleITK
#' @return returns a antsImage
#' @export
sitk2antsImage <- function(image) {
  if (!require(SimpleITK))
    stop("please install SimpleITK R-package")
  pixeltype <- image$GetPixelIDTypeAsString()
  pitype <- "float"
  #if (grepl("unsigned integer",pixeltype))
  #    pitype <- "unsigned int"
  #if (grepl("unsigned char",pixeltype))
  #    pitype <- "unsigned char"
  arr <- SimpleITK::as.array(image)
  dir <- image$GetDirection()
  aImage <- as.antsImage(arr,spacing=image$GetSpacing(),origin=image$GetOrigin(),pixeltype=pitype)
  antsSetDirection(aImage, matrix(dir,sqrt(length(dir)),sqrt(length(dir)),byrow = TRUE))
  return(aImage)
}

#' convert an antsImage to a SimpleITK image
#'
#' convert an antsImage to a SimpleITK image
#' @param image object of class antsImage
#' @return returns a SimpleITK image
#' @export

antsImage2sitk <- function(image) {
  if (!require(SimpleITK))
    stop("please install SimpleITK R-package")
  pixeltype <- image@pixeltype
  #arr <- ANTsR::as.array(image)
  arr <- ANTsRCore::getPixels(image, 
                              i=1:dim(image)[1],
                              j=1:dim(image)[2],
                              k=1:dim(image)[3])
  ci <- CastImageFilter()
  if (grepl("unsigned", pixeltype)) {
    storage.mode(arr) <- "integer"
    ci$SetOutputPixelType("sitkUInt16")
  } else
    ci$SetOutputPixelType("sitkFloat32")
  
  sitkImage <- SimpleITK::as.image(arr,spacing=antsGetSpacing(image),origin=antsGetOrigin(image))
  sitkImage$SetDirection(as.vector(t(antsGetDirection(image))))
  sitkImage <- ci$Execute(sitkImage)
  
  return(sitkImage)
}

library(SimpleITK)
filter=function(I) {
  
  i=ReadImage(I)
  filter=IsoDataThresholdImageFilter()
  o=filter$Execute(i)
  return (filter$GetThreshold())
}


image = sitk.ReadImage(f[1])

rescale_8bit  = function(image){
  min = min(image)
  max = max(image)
  temp = (image - min) * 255 / (max - min)
  return(temp)
}
