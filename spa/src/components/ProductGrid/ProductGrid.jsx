import ProductCard from '../ProductCard/ProductCard'
import './ProductGrid.css'

function ProductGrid({ products }) {
  if (!products || products.length === 0) return null

  return (
    <div className="product-list">
      <h2>Product Details</h2>
      <div className="product-grid">
        {products.map(product => (
          <ProductCard 
            key={product.id} 
            product={product}
          />
        ))}
      </div>
    </div>
  )
}

export default ProductGrid 