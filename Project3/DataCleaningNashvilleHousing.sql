/*
Cleaning Data with SQL Queries
*/
SELECT *
FROM PortfolioProject1..NashvilleHousing




-------------------------------------------------------------------------------------------
-- Standardize Date ("SaleDate") Format
SELECT
    SaleDate,
    CONVERT(date, SaleDate)
FROM PortfolioProject1..NashvilleHousing


UPDATE 
    PortfolioProject1..NashvilleHousing
SET
    SaleDate = CONVERT(date,SaleDate)


ALTER TABLE PortfolioProject1..NashvilleHousing
ADD SaleDateConverted date


UPDATE 
    PortfolioProject1..NashvilleHousing
SET
    SaleDateConverted = CONVERT(date,SaleDate)


SELECT
    SaleDate,
    SaleDateConverted
FROM PortfolioProject1..NashvilleHousing




-------------------------------------------------------------------------------------------
-- Populated "PropertyAddress" column
SELECT
    PropertyAddress
FROM PortfolioProject1..NashvilleHousing
WHERE
    PropertyAddress is NULL


-- Here, UniqueID is different but the rows having NULL values have same ParcelID with a row above. 
-- It is quite certain. We need to join the table with itself first.
SELECT
    *
FROM PortfolioProject1..NashvilleHousing as a
JOIN PortfolioProject1..NashvilleHousing as b
ON
    a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID


-- Then Let's check Out the parcelId and PropertyAddress Segment from the result of the query written above
SELECT
    a.UniqueID, a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress
FROM PortfolioProject1..NashvilleHousing as a
JOIN PortfolioProject1..NashvilleHousing as b
ON
    a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE
    a.PropertyAddress is NULL


-- Then Let's replace the null values of a.propertyAddress by taking values from b.propertyAddress
SELECT
    a.UniqueID, a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject1..NashvilleHousing as a
JOIN PortfolioProject1..NashvilleHousing as b
ON
    a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE
    a.PropertyAddress is NULL


-- Now that we have seen the process roughly, let's update the values
UPDATE
    a -- reference of the table
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) -- we can also replace a.propertyAddress with any sort of string. we might add "No address" there. It will populate the NULL values with that particular string then.
FROM PortfolioProject1..NashvilleHousing as a
JOIN PortfolioProject1..NashvilleHousing as b
ON
    a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE
    a.PropertyAddress is NULL


-- Now that the rows have been affected, Let's check it out
SELECT 
    PropertyAddress
FROM PortfolioProject1..NashvilleHousing




-------------------------------------------------------------------------------------------
-- Breaking out the address into individual addresses namely "Address", "City", "State".
-- We will need substring or "SUBSTRING" here.
SELECT
    PropertyAddress
FROM PortfolioProject1..NashvilleHousing

--From the aforementioned query, we can see that there is only one delimiter in every row and that is a COMMA
--SUBSTRING(string, start, length/Character to find). In the CHARINDEX section, in the part where we put the delimiter, we can also replace that with any string. if we replace that comma with "Protik", It will show result upto Protik.
-- -1 here is a representation of an index or a position
-- for the 2nd substring, we need to go from the next item of comma upto the end of the string
SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
FROM PortfolioProject1..NashvilleHousing


-- Now that we have the city and address, we will be updating the table and add them
-- Alter the table to add PropertySplitAddress
ALTER TABLE
    PortfolioProject1..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

-- Now Just Update command
UPDATE
    PortfolioProject1..NashvilleHousing
SET 
    PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

-- Now check if that's okay
SELECT
    PropertySplitAddress
FROM
    PortfolioProject1..NashvilleHousing


-- Alter the table to add PropertySplitCity
ALTER TABLE
    PortfolioProject1..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

-- Now Just Update command
UPDATE
    PortfolioProject1..NashvilleHousing
SET 
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

-- Now check if that's okay
SELECT
    PropertySplitCity
FROM
    PortfolioProject1..NashvilleHousing

-- That is done smoothly. look at them at once
SELECT
    PropertySplitAddress, PropertySplitCity
FROM 
    PortfolioProject1..NashvilleHousing


-- We can use "OwnerAddress" column to extract the State Name.
-- We can use SUBSTRING to do so.
-- But I think it will be a nice touch to use a different method
-- I will be use PARSENAME command here
-- Parsename parses a string after a FULLSTOP. 
-- BUT... We can modify that a bit 

SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
FROM 
    PortfolioProject1..NashvilleHousing


-- ADDing OwnerSplitAddress as a new column to the table
ALTER TABLE
    PortfolioProject1..NashvilleHousing
ADD
    OwnerSplitAddress NVARCHAR(255)

--UPDATE The values here on the column just created
UPDATE
    PortfolioProject1..NashvilleHousing
SET
    OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

--Check out the values
SELECT
    OwnerSplitAddress
FROM   
    PortfolioProject1..NashvilleHousing


-- ADDing OwnerSplitCity as a new column to the table
ALTER TABLE
    PortfolioProject1..NashvilleHousing
ADD
    OwnerSplitCity NVARCHAR(255)

--UPDATE The values here on the column just created
UPDATE
    PortfolioProject1..NashvilleHousing
SET
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

--Check out the values
SELECT
    OwnerSplitCity
FROM   
    PortfolioProject1..NashvilleHousing


-- ADDing OwnerSplitState as a new column to the table
ALTER TABLE
    PortfolioProject1..NashvilleHousing
ADD
    OwnerSplitState NVARCHAR(255)

--UPDATE The values here on the column just created
UPDATE
    PortfolioProject1..NashvilleHousing
SET
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Check out the values
SELECT
    OwnerSplitState
FROM   
    PortfolioProject1..NashvilleHousing




-------------------------------------------------------------------------------------------
-- Change Values to Y and N in "Sold vs Vacant" field to Yes and NO
-- Let's Check out the distinct values
SELECT
    DISTINCT(SoldAsVacant)
FROM 
    PortfolioProject1..NashvilleHousing


-- Let's Check out the distinct values with values
SELECT
    DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM 
    PortfolioProject1..NashvilleHousing
GROUP BY
    SoldAsVacant
ORDER BY    
    2


-- Let's use CASE_WHEN here

SELECT
    SoldAsVacant,
    CASE WHEN SoldAsVacant='Y' THEN 'Yes'
         WHEN SoldAsVacant='N' THEN 'NO'
    ELSE 
        SoldAsVacant
    END
FROM
    PortfolioProject1..NashvilleHousing


-- Now that we have the raw code, we can replace the value now
UPDATE 
    PortfolioProject1..NashvilleHousing
SET
    SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
                        WHEN SoldAsVacant='N' THEN 'NO'
                        ELSE 
                            SoldAsVacant
                        END


-- Let's check out if we have any Y and N left in the column
SELECT
    DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM 
    PortfolioProject1..NashvilleHousing
GROUP BY
    SoldAsVacant
ORDER BY    
    2




-------------------------------------------------------------------------------------------
-- Remove Duplicates
-- We need a CTE. But first it is convenient for me to write the inside query.
-- If the column inside the OVER clause followed by PARTITION BY are same, then the column is duplicate.
-- The Following query will mark duplicate ones with value greter than 1.
-- That thing has to be ordered by Unique value to be separated.
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION by
                       ParcelID,
                       PropertyAddress,
                       SalePrice,
                       LegalReference
                       ORDER BY
                            UniqueID) as Row_Num
FROM 
    PortfolioProject1..NashvilleHousing


-- Now putting this inside the CTE
WITH RowNumCTE AS
(
    SELECT
    *,
    ROW_NUMBER() OVER (PARTITION by
                       ParcelID,
                       PropertyAddress,
                       SalePrice,
                       LegalReference
                       ORDER BY
                            UniqueID) as Row_Num
    FROM 
        PortfolioProject1..NashvilleHousing
)

SELECT
    *
FROM 
    RowNumCTE
WHERE
    Row_Num > 1

-- To DELETE these entries
WITH RowNumCTE AS
(
    SELECT
    *,
    ROW_NUMBER() OVER (PARTITION by
                       ParcelID,
                       PropertyAddress,
                       SalePrice,
                       LegalReference
                       ORDER BY
                            UniqueID) as Row_Num
    FROM 
        PortfolioProject1..NashvilleHousing
)


DELETE
FROM   
    RowNumCTE
WHERE
    Row_Num > 1




-- DELETE Unused Columns
SELECT 
    * 
FROM
    PortfolioProject1..NashvilleHousing

ALTER TABLE
    PortfolioProject1..NashvilleHousing
DROP COLUMN
    PropertyAddress,
    SaleDate,
    OwnerAddress

SELECT 
    * 
FROM
    PortfolioProject1..NashvilleHousing
