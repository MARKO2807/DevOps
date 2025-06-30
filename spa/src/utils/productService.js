const API_URL = 'https://dummyjson.com/products'

export const fetchRandomProducts = async (count = 10) => {
  try {
    const response = await fetch(API_URL)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const data = await response.json()
    
    const shuffled = data.products.sort(() => 0.5 - Math.random())
    const randomProducts = shuffled.slice(0, count)
    
    return randomProducts
  } catch (error) {
    console.error('Error fetching products:', error)
    throw new Error('Failed to fetch products. Please check your internet connection.')
  }
} 