import React, { useState, useRef } from 'react';
import { Plus, Edit, Trash2, Save, X, Package, Upload } from 'lucide-react';
import type { Product, ProductVariation } from '../types';
import { useMenu } from '../hooks/useMenu';
import { useImageUpload } from '../hooks/useImageUpload';

interface VariationManagerProps {
  product: Product;
  onClose: () => void;
}

const VariationManager: React.FC<VariationManagerProps> = ({ product, onClose }) => {
  const { addVariation, updateVariation, deleteVariation } = useMenu();
  const { uploadImage, uploading } = useImageUpload('variation-images');
  const editFileInputRef = useRef<HTMLInputElement>(null);
  const newFileInputRef = useRef<HTMLInputElement>(null);
  const [isAdding, setIsAdding] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);

  const [newVariation, setNewVariation] = useState({
    name: '',
    quantity_mg: 5.0,
    price: product.base_price,
    stock_quantity: 0,
    image_url: ''
  });

  const [editingVariation, setEditingVariation] = useState({
    name: '',
    quantity_mg: 5.0,
    price: product.base_price,
    stock_quantity: 0,
    image_url: ''
  });

  const handleAddVariation = async () => {
    if (!newVariation.name || newVariation.price <= 0 || newVariation.quantity_mg <= 0) {
      alert('Please fill in all fields correctly');
      return;
    }

    try {
      setIsProcessing(true);
      const result = await addVariation({
        product_id: product.id,
        name: newVariation.name,
        quantity_mg: newVariation.quantity_mg,
        price: newVariation.price,
        stock_quantity: newVariation.stock_quantity,
        image_url: newVariation.image_url || undefined
      });

      if (result.success) {
        setNewVariation({
          name: '',
          quantity_mg: 5.0,
          price: product.base_price,
          stock_quantity: 0,
          image_url: ''
        });
        setIsAdding(false);
        alert('Variation added successfully!');
      } else {
        alert(result.error || 'Failed to add variation');
      }
    } catch (error) {
      alert('Failed to add variation');
    } finally {
      setIsProcessing(false);
    }
  };

  const handleEditVariation = (variation: ProductVariation) => {
    setEditingId(variation.id);
    setEditingVariation({
      name: variation.name,
      quantity_mg: variation.quantity_mg,
      price: variation.price,
      stock_quantity: variation.stock_quantity,
      image_url: variation.image_url || ''
    });
    setIsAdding(false);
  };

  const handleUpdateVariation = async () => {
    if (!editingId || !editingVariation.name || editingVariation.price <= 0 || editingVariation.quantity_mg <= 0) {
      alert('Please fill in all fields correctly');
      return;
    }

    try {
      setIsProcessing(true);
      const result = await updateVariation(editingId, {
        ...editingVariation,
        image_url: editingVariation.image_url || undefined
      });
      if (result.success) {
        setEditingId(null);
        alert('Variation updated successfully!');
      } else {
        alert(result.error || 'Failed to update variation');
      }
    } catch (error) {
      alert('Failed to update variation');
    } finally {
      setIsProcessing(false);
    }
  };

  const handleDeleteVariation = async (id: string, name: string) => {
    if (!confirm(`Delete ${name} variation? This cannot be undone.`)) return;

    try {
      setIsProcessing(true);
      const result = await deleteVariation(id);
      if (result.success) {
        alert('Variation deleted successfully!');
      } else {
        alert(result.error || 'Failed to delete variation');
      }
    } catch (error) {
      alert('Failed to delete variation');
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="bg-theme-bg border-b border-gray-200 p-4 md:p-6">
          <div className="flex items-start justify-between">
            <div className="flex-1 min-w-0">
              <h2 className="text-lg md:text-xl font-bold text-theme-text flex items-center gap-2">
                <Package className="w-5 h-5 md:w-6 md:h-6 text-theme-accent" />
                Manage Variations
              </h2>
              <p className="text-sm text-gray-500 mt-1 truncate">Product: {product.name}</p>
              <p className="text-xs text-theme-accent mt-2 bg-theme-accent/10 px-3 py-1.5 rounded-lg inline-block">
                💡 <strong>These prices</strong> are what customers see!
              </p>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors ml-2"
            >
              <X className="w-5 h-5 md:w-6 md:h-6 text-gray-500" />
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-6 overflow-y-auto max-h-[calc(90vh-180px)]">
          {/* Current Variations */}
          <div className="mb-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
              Current Variations
              <span className="text-sm font-normal text-gray-500">
                ({product.variations?.length || 0} variations)
              </span>
            </h3>

            {!product.variations || product.variations.length === 0 ? (
              <div className="bg-gray-50 border-2 border-dashed border-gray-300 rounded-xl p-8 text-center">
                <Package className="w-12 h-12 text-gray-400 mx-auto mb-3" />
                <p className="text-gray-600 font-medium">No size variations yet</p>
                <p className="text-sm text-gray-500 mt-1">Add your first size option below</p>
              </div>
            ) : (
              <div className="space-y-3">
                {product.variations.map((variation) => (
                  <div key={variation.id}>
                    {editingId === variation.id ? (
                      // Edit Mode
                      <div className="bg-white border-2 border-blue-300 rounded-xl p-4 space-y-4">
                        <h4 className="font-bold text-gray-900 mb-4">Edit Variation</h4>

                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-2">
                              Variation Name *
                            </label>
                            <input
                              type="text"
                              value={editingVariation.name}
                              onChange={(e) => setEditingVariation({ ...editingVariation, name: e.target.value })}
                              className="input-field"
                            />
                          </div>

                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-2">
                              Quantity (mg) *
                            </label>
                            <input
                              type="number"
                              step="0.1"
                              value={editingVariation.quantity_mg}
                              onChange={(e) => setEditingVariation({ ...editingVariation, quantity_mg: parseFloat(e.target.value) || 0 })}
                              className="input-field"
                            />
                          </div>

                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-2">
                              Price (₱) *
                            </label>
                            <input
                              type="number"
                              step="0.01"
                              value={editingVariation.price}
                              onChange={(e) => setEditingVariation({ ...editingVariation, price: parseFloat(e.target.value) || 0 })}
                              className="input-field"
                            />
                          </div>

                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-2">
                              Stock Quantity *
                            </label>
                            <input
                              type="number"
                              value={editingVariation.stock_quantity}
                              onChange={(e) => setEditingVariation({ ...editingVariation, stock_quantity: parseInt(e.target.value) || 0 })}
                              className="input-field"
                            />
                          </div>
                        </div>

                        {/* Image Upload */}
                        <div className="mt-4">
                          <label className="block text-sm font-semibold text-gray-700 mb-2">
                            Variation Image (Optional)
                          </label>
                          <div className="flex items-center gap-3">
                            {editingVariation.image_url ? (
                              <div className="relative">
                                <img
                                  src={editingVariation.image_url}
                                  alt="Variation"
                                  className="w-16 h-16 object-cover rounded-lg border border-gray-200"
                                />
                                <button
                                  type="button"
                                  onClick={() => setEditingVariation({ ...editingVariation, image_url: '' })}
                                  className="absolute -top-2 -right-2 p-1 bg-red-500 text-white rounded-full text-xs"
                                >
                                  <X className="w-3 h-3" />
                                </button>
                              </div>
                            ) : (
                              <div
                                onClick={() => editFileInputRef.current?.click()}
                                className="w-16 h-16 border-2 border-dashed border-gray-300 rounded-lg flex items-center justify-center cursor-pointer hover:border-theme-accent transition-colors"
                              >
                                {uploading ? (
                                  <div className="animate-spin w-5 h-5 border-2 border-theme-accent border-t-transparent rounded-full" />
                                ) : (
                                  <Upload className="w-5 h-5 text-gray-400" />
                                )}
                              </div>
                            )}
                            <input
                              ref={editFileInputRef}
                              type="file"
                              accept="image/*"
                              className="hidden"
                              onChange={async (e) => {
                                const file = e.target.files?.[0];
                                if (file) {
                                  try {
                                    const url = await uploadImage(file);
                                    setEditingVariation({ ...editingVariation, image_url: url });
                                  } catch (err) {
                                    alert('Failed to upload image');
                                  }
                                }
                                e.target.value = '';
                              }}
                            />
                            <span className="text-xs text-gray-500">Click to upload</span>
                          </div>
                        </div>

                        <div className="flex gap-3 pt-4">
                          <button
                            onClick={handleUpdateVariation}
                            disabled={isProcessing}
                            className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white rounded-xl font-bold transition-all shadow-md hover:shadow-lg disabled:opacity-50"
                          >
                            <Save className="w-5 h-5" />
                            Save Changes
                          </button>
                          <button
                            onClick={() => setEditingId(null)}
                            disabled={isProcessing}
                            className="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-xl font-medium transition-all"
                          >
                            Cancel
                          </button>
                        </div>
                      </div>
                    ) : (
                      // View Mode
                      <div className="bg-white border border-gray-200 rounded-xl p-3 md:p-4">
                        <div className="flex items-center gap-3">
                          {/* Thumbnail */}
                          {variation.image_url ? (
                            <img
                              src={variation.image_url}
                              alt={variation.name}
                              className="w-10 h-10 md:w-12 md:h-12 object-cover rounded-lg border border-gray-200 flex-shrink-0"
                            />
                          ) : (
                            <div className="w-10 h-10 md:w-12 md:h-12 bg-gray-50 rounded-lg flex items-center justify-center flex-shrink-0">
                              <Package className="w-4 h-4 md:w-5 md:h-5 text-gray-400" />
                            </div>
                          )}
                          {/* Info - stacked on mobile */}
                          <div className="flex-1 min-w-0">
                            <div className="font-bold text-gray-900 text-sm md:text-base truncate">{variation.name}</div>
                            <div className="flex flex-wrap gap-x-3 gap-y-0.5 text-xs md:text-sm text-gray-500 mt-0.5">
                              <span>₱{variation.price.toLocaleString()}</span>
                              <span>{variation.stock_quantity} units</span>
                            </div>
                          </div>
                          {/* Actions */}
                          <div className="flex gap-1 flex-shrink-0">
                            <button
                              onClick={() => handleEditVariation(variation)}
                              disabled={isProcessing}
                              className="p-1.5 md:p-2 text-theme-accent hover:bg-theme-accent/10 rounded-lg transition-colors disabled:opacity-50"
                              title="Edit variation"
                            >
                              <Edit className="w-4 h-4 md:w-5 md:h-5" />
                            </button>
                            <button
                              onClick={() => handleDeleteVariation(variation.id, variation.name)}
                              disabled={isProcessing}
                              className="p-1.5 md:p-2 text-red-500 hover:bg-red-50 rounded-lg transition-colors disabled:opacity-50"
                              title="Delete variation"
                            >
                              <Trash2 className="w-4 h-4 md:w-5 md:h-5" />
                            </button>
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Add New Variation */}
          <div className="border-t-2 border-gray-200 pt-6">
            <button
              onClick={() => {
                setIsAdding(!isAdding);
                setEditingId(null); // Close edit mode when adding new
              }}
              className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-600 hover:to-emerald-700 text-white rounded-lg font-medium transition-all shadow-md hover:shadow-lg mb-4"
            >
              <Plus className="w-5 h-5" />
              {isAdding ? 'Cancel' : 'Add New Variation'}
            </button>

            {isAdding && (
              <div className="bg-white border-2 border-teal-300 rounded-xl p-6 space-y-4">
                <h4 className="font-bold text-gray-900 mb-4">New Variation</h4>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      Variation Name *
                    </label>
                    <input
                      type="text"
                      value={newVariation.name}
                      onChange={(e) => setNewVariation({ ...newVariation, name: e.target.value })}
                      placeholder="e.g., 5mg, 10mg, 20mg"
                      className="input-field"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      Quantity (mg) *
                    </label>
                    <input
                      type="number"
                      step="0.1"
                      value={newVariation.quantity_mg}
                      onChange={(e) => setNewVariation({ ...newVariation, quantity_mg: parseFloat(e.target.value) || 0 })}
                      className="input-field"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      Price (₱) *
                    </label>
                    <input
                      type="number"
                      step="0.01"
                      value={newVariation.price}
                      onChange={(e) => setNewVariation({ ...newVariation, price: parseFloat(e.target.value) || 0 })}
                      className="input-field"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      Stock Quantity *
                    </label>
                    <input
                      type="number"
                      value={newVariation.stock_quantity}
                      onChange={(e) => setNewVariation({ ...newVariation, stock_quantity: parseInt(e.target.value) || 0 })}
                      className="input-field"
                    />
                  </div>
                </div>

                {/* Image Upload */}
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Variation Image (Optional)
                  </label>
                  <div className="flex items-center gap-3">
                    {newVariation.image_url ? (
                      <div className="relative">
                        <img
                          src={newVariation.image_url}
                          alt="Preview"
                          className="w-16 h-16 object-cover rounded-lg border border-gray-200"
                        />
                        <button
                          type="button"
                          onClick={() => setNewVariation({ ...newVariation, image_url: '' })}
                          className="absolute -top-2 -right-2 p-1 bg-red-500 text-white rounded-full text-xs"
                        >
                          <X className="w-3 h-3" />
                        </button>
                      </div>
                    ) : (
                      <div
                        onClick={() => newFileInputRef.current?.click()}
                        className="w-16 h-16 border-2 border-dashed border-gray-300 rounded-lg flex items-center justify-center cursor-pointer hover:border-theme-accent transition-colors"
                      >
                        {uploading ? (
                          <div className="animate-spin w-5 h-5 border-2 border-theme-accent border-t-transparent rounded-full" />
                        ) : (
                          <Upload className="w-5 h-5 text-gray-400" />
                        )}
                      </div>
                    )}
                    <input
                      ref={newFileInputRef}
                      type="file"
                      accept="image/*"
                      className="hidden"
                      onChange={async (e) => {
                        const file = e.target.files?.[0];
                        if (file) {
                          try {
                            const url = await uploadImage(file);
                            setNewVariation({ ...newVariation, image_url: url });
                          } catch (err) {
                            alert('Failed to upload image');
                          }
                        }
                        e.target.value = '';
                      }}
                    />
                    <span className="text-xs text-gray-500">Click to upload</span>
                  </div>
                </div>

                <div className="flex gap-3 pt-4">
                  <button
                    onClick={handleAddVariation}
                    disabled={isProcessing}
                    className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-600 hover:to-emerald-700 text-white rounded-xl font-bold transition-all shadow-md hover:shadow-lg disabled:opacity-50"
                  >
                    <Save className="w-5 h-5" />
                    Save Variation
                  </button>
                  <button
                    onClick={() => setIsAdding(false)}
                    disabled={isProcessing}
                    className="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-xl font-medium transition-all"
                  >
                    Cancel
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Footer */}
        <div className="bg-gray-50 border-t border-gray-200 p-4 flex justify-end">
          <button
            onClick={onClose}
            className="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-xl font-medium transition-all"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
};

export default VariationManager;

