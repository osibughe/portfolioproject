SELECT *
FROM portfolioProject.dbo.NashvilleHousingData


--Populate Property Address data

SELECT *
FROM portfolioProject.dbo.NashvilleHousingData
--Where PropertyAddress is null
Order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolioProject.dbo.NashvilleHousingData as a
Join portfolioProject.dbo.NashvilleHousingData as b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolioProject.dbo.NashvilleHousingData as a
Join portfolioProject.dbo.NashvilleHousingData as b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Breaking out Address Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM portfolioProject.dbo.NashvilleHousingData
--Where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM portfolioProject.dbo.NashvilleHousingData


ALTER TABLE portfolioProject.dbo.NashvilleHousingData
ADD PropertySplitAddress Nvarchar(255);

update portfolioProject.dbo.NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE portfolioProject.dbo.NashvilleHousingData
ADD PropertySplitCity Nvarchar(255);

update portfolioProject.dbo.NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM portfolioProject.dbo.NashvilleHousingData



SELECT OwnerAddress
FROM portfolioProject.dbo.NashvilleHousingData


SELECT
SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) -1) as OwnerAddress
, SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) +1, LEN(OwnerAddress)) as OwnerCity

FROM portfolioProject.dbo.NashvilleHousingData


ALTER TABLE portfolioProject.dbo.NashvilleHousingData
ADD OwnerSplitAddress Nvarchar(255);

update portfolioProject.dbo.NashvilleHousingData
SET OwnerSplitAddress = SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) -1)

ALTER TABLE portfolioProject.dbo.NashvilleHousingData
ADD OwnerSplitCity Nvarchar(255);

update portfolioProject.dbo.NashvilleHousingData
SET OwnerSplitCity = SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) +1, LEN(OwnerAddress))


SELECT *
FROM portfolioProject.dbo.NashvilleHousingData


--count 1 and 0 in "sold as vacant' field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolioProject.dbo.NashvilleHousingData
Group by SoldAsVacant
Order by 2


--Remove Duplicate

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					LegalReference
					ORDER BY UniqueID
					) row_num

FROM portfolioProject.dbo.NashvilleHousingData
--Order by ParcelID
)

--Replace the Select* below with DELETE and then back to select* to remove duplicates
SELECT *
FROM RowNumCTE
Where row_num > 1
order by PropertyAddress


--Delete unused columns

SELECT *
FROM portfolioProject.dbo.NashvilleHousingData

ALTER TABLE portfolioProject.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE portfolioProject.dbo.NashvilleHousingData
DROP COLUMN SaleDate

