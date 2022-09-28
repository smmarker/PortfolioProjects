/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  --Cleaning data in SQL queries
  
  SELECT *
  FROM PortfolioProject..NashvilleHousing

  --Standardize Date Format
  --remove the time stamp

   SELECT SaleDate
  FROM PortfolioProject..NashvilleHousing

  ALTER TABLE NashvilleHousing
  ADD SaleDateConverted DATE;
  
  UPDATE NashvilleHousing
  SET SaleDateConverted = CONVERT(Date,SaleDate)

  SELECT SaleDateConverted
  FROM PortfolioProject..NashvilleHousing

  --Populate Property Address data

  SELECT PropertyAddress
  FROM PortfolioProject..NashvilleHousing
  
  SELECT PropertyAddress
  FROM PortfolioProject..NashvilleHousing
  WHERE PropertyAddress is null

  SELECT PropertyAddress
  FROM PortfolioProject..NashvilleHousing
  --WHERE PropertyAddress is null
  ORDER BY ParcelID

  --ParcelID and address match over multiple entries
  
  SELECT *
  FROM PortfolioProject..NashvilleHousing a
  JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject..NashvilleHousing a
  JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

--update to fill null values with address associated with parcel ID 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
  JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

  --Breaking out Address Into Columns (Address, City, State)

  SELECT PropertyAddress
  FROM PortfolioProject..NashvilleHousing
  --WHERE PropertyAddress is null
  --ORDER BY ParcelID

  SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address
  FROM PortfolioProject..NashvilleHousing

  -- using the -1 eliminates the comma after the address
  -- using the +1 begins 1 character in front of the comma
  
  SELECT 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
  FROM PortfolioProject..NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress Nvarchar(255);

 UPDATE
 NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity Nvarchar(255);
 
 UPDATE
 NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

 SELECT *
  FROM PortfolioProject..NashvilleHousing

  --break out owner address by address, city, state

  SELECT OwnerAddress
  FROM PortfolioProject..NashvilleHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
  FROM PortfolioProject..NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress Nvarchar(255);
 
 UPDATE
 NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity Nvarchar(255);

 UPDATE
 NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitState Nvarchar(255);

 UPDATE
 NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

 --Change Y and N to Yes and No in "Sold as Vacant" field

 SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
 FROM PortfolioProject..NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER BY 2

 SELECT SoldAsVacant 
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject..NashvilleHousing




UPDATE NashvilleHousing
SET SoldASVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject..NashvilleHousing

--Remove duplicates
WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
			UniqueID
			) row_num

FROM PortfolioProject..NashvilleHousing
--ORDER BY ParcelID
)

--COMMENTED OUT TO TEST IF DELETE WAS SUCCESSFUL
--DELETE
--FROM RowNumCTE
--WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--Delete Unused Columns

SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate