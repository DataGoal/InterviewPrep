def twoSum(nums, target):
    # https://leetcode.com/problems/two-sum/description/
    # Jan 10 2025
    d = {}
    for k, v in enumerate(nums, 0):
        if target-v in d:
            return (d[target-v], k)
        else:
            d[v] = k

def hasDuplicate(nums):
    # https://leetcode.com/problems/contains-duplicate/
    # Jan 11 2025
    d = {}
    for i in nums:
        if i not in d:
            d[i] = 1
        else:
            return True
    return False 

def isAnagram(s, t):
    # https://leetcode.com/problems/valid-anagram/
    # Jan 11 2025
    if len(s) != len(t):
        return False

    s_map, t_map = {}, {}

    for i in s:
        if i not in s_map:
            s_map[i] = 1
        else:
            s_map[i] += 1

    for j in t:
        if j not in t_map:
            t_map[j] = 1
        else:
            t_map[j] += 1

    return sorted(s_map) == sorted(t_map)    
   

def twoPointerTwoSum(nums, target):
    # https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/
    # Jan 12 2025
    left, right = 0, len(nums)-1

    while left < right:
        curr_sum = nums[left] + nums[right]
        if curr_sum == target:
            return (nums[left], nums[right])
        elif curr_sum < target:
            left += 1
        else:
            right -= 1
    return None        

    
def romanToInt(s):
    # https://leetcode.com/problems/roman-to-integer/
    # Jan 13 2025
    d = {'I':1,'V':5,'X':10,'L':50,'C':100,'D':500,'M':1000}
    s_rev = s[::-1]
    a = 0
    prev_val = 0
    for i in s_rev:
        if d[i] < prev_val:
            a -= d[i]
        else:
            a += d[i]
        prev_val = d[i]
    return a

def reverseStr(s):
    a = ''
    for i in s:
        a = i + a
    return a  

def cumliativeSum(nums):
    a = 0
    b = []
    for i in nums:
        a = a + i
        b.append(a)
    return b  

def numToIntList(s):
    a = []
    for i in str(s): 
        a.append(i)
    return a    

def isPalindromeNum(x):
    # https://leetcode.com/problems/palindrome-number/
    if x < 0:
        return False
    newNum = 0
    inputNum = x
    while x > 0:
        newNum = newNum * 10 + x % 10
        x = x//10
    return inputNum == newNum  



if __name__ == '__main__':
    print('PyCharm')


# print(twoSum([2, 5, 3, 6], 8))
# print(hasDuplicate([1,2,3,4,2]))  
# print(isAnagram('bala','bala'))
# print(removeDuplicates([0,0,1,1,1,2,2,3,3,4]))    
# print(twoPointerTwoSum([2,7,11,15],26))
# print(romanToInt('IV'))  
# print(reverseStr('bhg')) 
# print(isPalindromeNum(121))    
# print(cumliativeSum([1,2,3]))
# print(numToIntList(12345))

