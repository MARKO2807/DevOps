import { useState, useEffect } from 'react'
import { fetchRandomProducts } from '../utils/productService'

export const useProducts = () => {
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const loadProducts = async () => {
    setLoading(true)
    setError(null)
    
    try {
      const randomProducts = await fetchRandomProducts(10)
      setProducts(randomProducts)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadProducts()
  }, [])

  return {
    products,
    loading,
    error,
    refreshProducts: loadProducts
  }
} 